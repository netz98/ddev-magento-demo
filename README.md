# ddev Magento Demo Project

![ddev Magento Demo Setup Banner](docs/images/ddev-Magento-Demo-Setup.gif)

This is a demo project with the purpose to demonstrate how the awesome ddev tool can be used to install a Magento system on a local machine. It should help to adopt ddev in your company for Magento development.
It is not a production setup.

ddev can also handle multiple PHP based projects at once.

The demo system is already pre-configured with this services:

- OpenSearch (search engine)
- OpenSearch Dashboards
- MySQL
- Redis (session and cache)

- Elasticsearch exists as disabled ddev service (search engine)
- Kibana exists as disabled ddev service (dev tools for Elasticsearch)

## Technical Requirements

Have ddev and Docker installed.
See:
- https://ddev.readthedocs.io/en/stable/#system-requirements
- https://ddev.readthedocs.io/en/stable/#docker-installation

## Start the project

```bash
git clone https://github.com/netz98/ddev-magento-demo.git
cd ddev-magento-demo
ddev start 
```

## Install Sample Data

The sample data is already included in the project. You can install it by running the following command:

```bash
ddev install-sample-data
```

## Change Magento Version

The Magento version is defined in `MAGENTO_VERSION` variable in the `.ddev/config.yaml` project config file.
Change the variable **MAGENTO_USE_OPENSEARCH** to the Composer version contraint of the Magento version you like.
If the Magento version does not require OpenSearch during the installation, then also set the variable **MAGENTO_USE_OPENSEARCH** to *false* (default is "true").

For older Magento versions you should also downgrade PHP (e.g. `ddev config --php-version=7.3`) 
and Composer if not compatible. `ddev config --composer-version=1`

## Admin Login and 2FA

The `Magento_TwoFactorAuth` modules is not disabled during the installation of Magento like in other tutorials.

We have a `ddev 2fa` command which helps to generate a authentication code for a admin login.

The default admin credentials are:

Username: admin  
Password: Password123  


## Important commands

```bash
# Login into container
ddev ssh

# See all project infos
ddev describe

# Run php in container
ddev exec php -v

# Run the bin/magento tool
ddev magento

# Run the n98-magerun2 tool
ddev exec magerun2

# Open project in browser
ddev launch

# Open PhpMyAdmin in browser
ddev launch -p

# Open Mailhog in browser
ddev launch -m

# Import a database dump
ddev import-db --src="<sql dump file>"

# Create a DB snapshot
ddev snapshot

# Restore snapshot
ddev snapshot restore

# Restore latest snapshot
ddev snapshot restore --latest

# Remove project and all Docker volumes
ddev rm --remove-data --omit-snapshot
```

## Debugging

XDebug is supported out of the box in ddev.
It can be enabled by `ddev xdebug on` and disabled by `ddev xdebug off`.
Alternativly you can login into container an run the `enable_xdebug` and `disable_xdebug` scripts which does not restart the Docker containers.

The project path has to be mapped in your debugger settings to `/var/www/html`.

A brief description can be found here:

https://ddev.readthedocs.io/en/stable/users/step-debugging/

## Mac Users

For a better Docker performance it's a good idea to enable NFS mount or use the Mutagen Sync integration.

```bash
ddev config --mutagen-enabled=true
```

If mutagen sync is already running on your host machine, then it's required to stop it before enabling the ddev Mutagen sync.

## Cleanup

Cleanup all files installed by Magento installation process.

```
ddev wipe-magento-files
```

## Useful ddev resources

Official Manual: https://ddev.readthedocs.io/en/stable/

Awesome ddev projects: https://github.com/drud/awesome-ddev

Github repository: https://github.com/drud/ddev

Additional services, tools, snippets, approaches.: https://github.com/drud/ddev-contrib
