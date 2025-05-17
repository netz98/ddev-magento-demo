#!/bin/bash

CURRENT_DIR=$(dirname "$0");
source "${CURRENT_DIR}/bash/helpers/colors.sh";
source "${CURRENT_DIR}/bash/lib/composer.sh";

# Configuration is defined in .ddev/config.yaml
# web_environment:
# - MAGENTO_VERSION="2.4.3-p1";
# - MAGENTO_USE_ELASTICSEARCH=true

MAGENTO_ROOT_DIR="/var/www/html";


function show_banner() {
    echo -e "${bldcyn}=========================================================="
    echo -e "> ddev Magento ${MAGENTO_VERSION} demo project by valantic CEC GmbH"
    echo -e "==========================================================${txtrst}"
    echo ""
    echo "... starting"
}

function install_magento() {
    if [ ! -f "./app/etc/env.php" ]; then
        echo -e "${bldcyn}=========================================================="
        echo -e "> Initial Magento ${MAGENTO_VERSION} Setup ..."
        echo -e "==========================================================${txtrst}"

        if [ ! -f composer.json ]; then
            # see: https://github.com/composer/composer/issues/10928#issuecomment-1181534484

            composer --no-interaction create-project \
                --no-install \
                --repository-url=https://repo.magento.com/ \
                magento/project-community-edition="$MAGENTO_VERSION" ./magento
            composer config -d ./magento "allow-plugins.dealerdirect/phpcodesniffer-composer-installer" true;
            composer config -d ./magento  "allow-plugins.dealerdirect/phpcodesniffer-composer-installer" true;
            composer config -d ./magento "allow-plugins.laminas/laminas-dependency-plugin" true;
            composer config -d ./magento "allow-plugins.magento/*" true;
            composer install -d ./magento;
            rm ./magento/.gitignore;
            mv ./magento/* /var/www/html;
            mv ./magento/.* /var/www/html;
            rm -Rf ./magento;
        fi

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
            "--cache-backend=redis"
            "--cache-backend-redis-server=valkey"
            "--cache-backend-redis-port=6379"
            "--cache-backend-redis-db=0"
            "--session-save=redis"
            "--session-save-redis-host=valkey"
            "--session-save-redis-port=6379"
            "--session-save-redis-log-level=3"
            "--session-save-redis-db=1"
            "--session-save-redis-disable-locking=1"
        )

        if [[ "$MAGENTO_USE_OPENSEARCH" == "true" ]]; then
            # Configure Standard Magento Elasticsearch
            MAGENTO_SETUP_ARGS+=(
                "--search-engine=opensearch"
                "--opensearch-host=opensearch"
                "--opensearch-port=9200"
            )
        fi
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
