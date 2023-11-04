![Gitpod for Magento 2 Development](http://www.develodesign.co.uk/gitpod.png)
[Click here to Learn more about Gitpod for Magento 2 on our Course](https://develo.teachable.com/p/mastering-gitpod-for-magento-2-development)

# Magento 2 Gitpod Cloud Development Environment

This repository contains a Gitpod configuration for a Magento 2 cloud development environment. 

The goal is to have a simple way of creating different configuraitons for Magento 2 dev environments, that begin quickly and require no further input to being using. 

  
# Getting Started
Once the Gitpod browser extension is installed [Download Extension](https://www.gitpod.io/docs/browser-extension), click the Gitpod button in Github to get started with a blank Magento 2 enviroment.

# Configuring Magento and the Server Env Versions
All configuration options including Magento versions and Admin login are found here [.gitpod.Dockerfile](https://github.com/develodesign/magento-gitpod/blob/main/.gitpod.Dockerfile). 

# Use in an Existing Project
- Copy the ```Gitpod``` folder, ```gitpod.yml``` and ```.gitpod.Dockerfile``` files to an existing Magento 2 repository to use on your own project.

# Installing an existing database
- Uncomment and complete the code [here](https://github.com/develodesign/magento-gitpod/blob/0880b246b9392d07d3655c740ba2f59376fd68f2/gitpod/m2-install.sh#L28) to have the script import an existing Magento 2 database. 
- Replace ```staging-domain.com``` in the file with your Magento 2 url, this will be replaced with the current gitpod workspace URL before import.
- Compress your .sql file and place into the gitpod folder as ```magento-db.sql.zip```
- Set INSTALL_MAGENTO = No in the [.gitpod.Dockerfile](https://github.com/develodesign/magento-gitpod/blob/main/.gitpod.Dockerfile)


# Road Map
- [x] Run Magento fully installed on load
- [x] Have no files marked as changed in GIT.
- [x] Install Magento SQL once on first load, delete flag to reinstall
- [x] Import staging SQL file replacing urls 
- [x] Improve config to simplify configuring the build components
- [x] Add MailPit SMTP mail catcher with zero config
- [x] Magento 2.4.6 and PHP8.2 support
- [x] Add additional SQL and config updates, Magento config for SMTP details, Algolia indexing etc. 
- [x] Accept values for Magento configuration through Gitpod ENV


# Credit
Based on the original Gitpod config produced by https://github.com/nemke82/magento2gitpod
