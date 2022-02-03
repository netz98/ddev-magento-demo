# ddev Magento Demo Project

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

## Change Magento Version

The Magento version is defined in the `.ddev/config.yaml` project config file.
Change the variable **MAGENTO_USE_ELASTICSEARCH** to the Composer version contraint of the Magento version you like.
If the Magento version does not require Elasticsearch during the installation, then also set the variable **MAGENTO_USE_ELASTICSEARCH** to *false* (default is "true").

## 2FA

The `Magento_TwoFactorAuth` modules is not disabled during the installation of Magento like in other tutorials.

We have a `ddev 2fa` command which helps to generate a authentication code for a admin login.

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
```

## Debugging

https://ddev.readthedocs.io/en/stable/users/step-debugging/

## Mac Users

For a better Docker performance it's a good idea to enable NFS mount or use the Mutagen Sync integration.

```bash
ddev config --mutagen-enabled=true
```

If mutagen sync is already running on your host machine, then it's required to stop it before enabling the ddev Mutagen sync.
