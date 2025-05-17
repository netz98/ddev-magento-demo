#!/bin/bash

# Load color helpers (assuming colors.sh is in the same directory structure)
CURRENT_DIR=$(dirname "${BASH_SOURCE[0]}");
source "${CURRENT_DIR}/../helpers/colors.sh";

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

function configure_composer_help() {
    echo -e "${txtred}=========================="
    echo -e "> STOP!"
    echo -e "==========================${txtrst}"
    echo ""
    echo -e "${txtylw}\$MAGENTO_REPO_USERNAME${txtrst} and ${txtylw}\$MAGENTO_REPO_PASSWORD${txtrst} environment variables are not set."
    echo ""
    echo -e "To set your Magento credentials globally for all ddev projects, edit your ${txtpur}~/.ddev/global_config.yaml${txtrst} file."
    echo ""
    echo "Add the following section (or add these lines if the section already exists):"
    echo ""
    echo -e "${bldcyn}web_environment:${txtrst}"
    echo -e "${bldcyn}- MAGENTO_REPO_USERNAME=<public-key>${txtrst}"
    echo -e "${bldcyn}- MAGENTO_REPO_PASSWORD=<private-key>${txtrst}"
    echo ""
    echo "Alternatively, you can set these using the ddev command:"
    echo ""
    echo -e "${bldcyn}ddev config global --web-environment-add \"MAGENTO_REPO_USERNAME=<public-key>\"${txtrst}"
    echo -e "${bldcyn}ddev config global --web-environment-add \"MAGENTO_REPO_PASSWORD=<private-key>\"${txtrst}"
    echo ""
    echo -e "Get your Magento authentication keys: ${txtblu}https://experienceleague.adobe.com/en/docs/commerce-operations/installation-guide/overview${txtrst}"
    echo -e "More infos about global environment variables in ddev: ${txtblu}https://ddev.readthedocs.io/en/stable/users/extend/customization-extendibility/#global-environment-variables${txtrst}"
    echo ""

    exit 1 # Exit the script after showing the help message
}
