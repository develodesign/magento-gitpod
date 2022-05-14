# Magento 2 Gitpod Cloud Development Environment

This repository is an example configuration for setting up Gitpod as a cloud development environment for Magento 2. 

The goal is to have a simple way of creating Magento 2 dev environments that begin quickly and require no further input.


## Getting Started
Once the Gitpod browser extension is installed [Download Extension](https://www.gitpod.io/docs/browser-extension), click the Gitpod button in Github to get started with a blank Magento 2 enviroment.


## Use in an Existing Project
Copy the Gitpod folder, gitpod.yml and Docker files to an existing Magento 2 repository to use on your own project.


## Installing an existing database
Uncomment and complete the code [here](https://github.com/develodesign/magento-gitpod/blob/0880b246b9392d07d3655c740ba2f59376fd68f2/gitpod/m2-install.sh#L28) to have the script import an existing Magento 2 database. 

Replace ```staging-domain.com``` in the file with your Magento 2 url, this will be replaced with the current gitpod workspace URL before import.

Compress your .sql file and place into the gitpod folder as ```magento-db.sql.zip```


### Road Map
- [x] Run Magento fully installed on load
- [x] Have no files marked as changed in GIT.
- [x] Install Magento SQL once on first load, delete flag to reinstall
- [x] Import staging SQL file replacing urls 
- [ ] Improve config to simplify configuring the build components
- [ ] Magento 2.4.4 and PHP8.1 support
- [ ] Add additional SQL and config updates, Magento config for SMTP details, Algolia indexing etc. 


## Credit
Based on the original Gitpod config produced by https://github.com/nemke82/magento2gitpod
