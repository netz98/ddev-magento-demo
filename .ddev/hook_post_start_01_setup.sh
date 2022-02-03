#!/bin/bash

CURRENT_DIR=$(dirname "$0");
source "${CURRENT_DIR}/bash/helpers/colors.sh";

# Configuration is defined in .ddev/config.yaml
# web_environment:
# - MAGENTO_VERSION="2.4.3-p1";
# - MAGENTO_USE_ELASTICSEARCH=true

MAGENTO_ROOT_DIR="/var/www/html";


function show_banner() {
	echo -e "${bldcyn}=========================================================="
	echo -e "> ddev Magento ${MAGENTO_VERSION} demo project by netz98 GmbH      "
	echo -e "==========================================================${txtrst}"
	echo ""
	echo "... starting"
}

function configure_composer_help() {
    echo -e "${txtred}=========================="
    echo -e "> STOP!"
    echo -e "==========================${txtrst}"
    echo ""
    echo -e "${txtylw}\$MAGENTO_REPO_USERNAME${txtrst} and ${txtylw}\$MAGENTO_REPO_PASSWORD${txtrst} environment variables are not set."
	echo ""
	echo -e "Edit ${txtpur}~/.ddev/global_config.yaml${txtrst} file and add your credentials there."
	echo ""
	echo "Example:"
    echo ""
	echo -e "${bldcyn}web_environment:${txtrst}"
    echo -e "${bldcyn}- MAGENTO_REPO_USERNAME=<public-key>${txtrst}"
    echo -e "${bldcyn}- MAGENTO_REPO_PASSWORD=<private-key>${txtrst}"
	echo ""
	echo -e "Get your Magento authentication keys: ${txtblu}https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html${txtrst}"
    echo -e "More infos about the ddev configuration: ${txtblu}https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/#providing-custom-environment-variables-to-a-container${txtrst}"
	echo ""

    exit 1
}

function setup_composer() {
    if [ -f /var/www/auth.json ]; then
        exit;
    fi

    if [ -z "$MAGENTO_REPO_USERNAME" ]; then
        configure_composer_help
    fi

    if [ -z "$MAGENTO_REPO_PASSWORD" ]; then
        configure_composer_help
    fi

    composer -q --ansi global config http-basic.repo.magento.com "$MAGENTO_REPO_USERNAME" "$MAGENTO_REPO_PASSWORD"
    echo -en "${txtgrn}${check_mark} Magento repo configured ${txtrst} \n"
}

function install_magento() {
	if [ ! -f "./app/etc/env.php" ]; then
		echo -e "${bldcyn}=========================================================="
		echo -e "> Initial Magento ${MAGENTO_VERSION} Setup ..."
		echo -e "==========================================================${txtrst}"

		composer --no-interaction create-project \
			--repository-url=https://repo.magento.com/ \
			magento/project-community-edition="$MAGENTO_VERSION" ./magento

		mv ./magento/* /var/www/html;
		rmdir ./magento;

		cd $MAGENTO_ROOT_DIR

		if [ -d "./generated" ]; then
			rm -Rf ./generated
		fi

		# build magento setup arguments
		MAGENTO_SETUP_ARGS=(
			"php" "bin/magento" "setup:install"
			"--no-interaction"
			"--db-host=db"
			"--db-user=db"
			"--db-password=db"
			"--db-name=db"
			"--cleanup-database"
			"--backend-frontname=admin"
			"--timezone=${TZ}"
			"--currency=EUR"
			"--base-url=${DDEV_PRIMARY_URL}"
			"--use-rewrites=1"
			"--use-secure=1"
			"--use-secure-admin=1"
			"--admin-user=admin"
			"--admin-password=Password123"
			"--admin-firstname=Armin"
			"--admin-lastname=Admin"
			"--admin-email=admin@example.com"
		)

		if [[ "$MAGENTO_USE_ELASTICSEARCH" == "true" ]]; then
			# Configure Standard Magento Elasticsearch
			MAGENTO_SETUP_ARGS+=(
				"--search-engine=elasticsearch7"
				"--elasticsearch-host=elasticsearch"
				"--elasticsearch-port=9200"
			)
		fi

		# Execute Magento installer based on setup arguments
		#echo ${MAGENTO_SETUP_ARGS[*]}  # debug
		command ${MAGENTO_SETUP_ARGS[*]}

    else
		echo -en "${txtgrn}${check_mark} Magento already installed ${txtrst} \n"		
	fi
}

function system_info() {
	magerun2 sys:info
}

show_banner
setup_composer
install_magento
system_info
