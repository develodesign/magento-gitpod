# Gitpod Magento 2 Cloud Development Environment

## Introduction
This repository serves as a springboard for developers to launch fully-configured Magento 2 development environments using Gitpod. With the focus on convenience and efficiency, it facilitates seamless Magento 2 development workflows in the cloud.
<br><br>

## Getting Started
To begin using this environment, you need to have a Gitpod account. Once you have your account set up, fork this repository and launch your workspace with a single click. Gitpod will read the configuration files and set up the environment accordingly.
<br><br>

## Features
**Pre-configured Magento 2:** A ready-to-code Magento 2 environment set up with sensible defaults to start coding immediately.

**Development Toolkit:** Includes ready to go tools that make you a super powered developer.

**Automated Setups:** On every Gitpod workspace launch, the environment automatically configures itself, eliminating the need for manual setup.

**Cloud-based Development:** Work from anywhere, on any machine, without the need to install and maintain a local development stack.
<br><br>

## Benefits of a Cloud Development Environment

**Portability:** Whether you’re at home, in the office, or on the go, your development environment is accessible from any device with an internet connection.

**Consistency:**  Every member of the team works within a standardized environment, reducing "it works on my machine" issues and streamlining collaboration.

**Scalability:** Resources can be scaled according to the project's demands without the need for physical hardware upgrades.

**Security:** With all code and data stored in the cloud, the security is centralized and can be managed more effectively than on individual local machines.

**Cost-Efficiency:** Reduce expenses on hardware and energy. Pay only for the resources you use, when you use them.

## Zero config required development tools
**MailPit :**
email catching and debugging

**Tab nine :**
A.I autocomplete code tool

**Cypress :**
A great testing tool

**Xdebug :**
PHP debugger ready to go
<br><br>
 
## How to Use
**Fork the Repository:**
Fork this repository to your GitHub account.

**Open in Gitpod:**
Click the Gitpod button on your forked repository to launch the development environment.

**Start Coding:**
Once the environment is ready, you can start coding immediately with Magento 2.
<br><br>

## Customization
To tailor the environment to your needs, you can modify the provided .gitpod.yml and .gitpod.Dockerfile configuration files. Add or remove services, extensions, and configurations as necessary for your project.
<br><br>

## Support
If you encounter any issues or have questions, please open an issue in the repository, and we'll address it as soon as possible.
<br><br>

## Contribution
Contributions are welcome! If you have suggestions or improvements, feel free to make a pull request.
<br><br>

Jumpstart your Magento 2 development with the efficiency and flexibility of a cloud-based environment. Try it now and experience a streamlined development workflow that lets you focus on coding, not configuration.

## Learn More
[Click here to Learn more about Gitpod for Magento 2 on our Free Teachable Course](https://develo.teachable.com/p/mastering-gitpod-for-magento-2-development)
<br><br>

## Installing an existing database
- Uncomment and complete the code [here](https://github.com/develodesign/magento-gitpod/blob/0880b246b9392d07d3655c740ba2f59376fd68f2/gitpod/m2-install.sh#L28) to have the script import an existing Magento 2 database. 
- Replace ```staging-domain.com``` in the file with your Magento 2 url, this will be replaced with the current gitpod workspace URL before import.
- Compress your .sql file and place into the gitpod folder as ```magento-db.sql.zip```
- Set INSTALL_MAGENTO = No in the [.gitpod.Dockerfile](https://github.com/develodesign/magento-gitpod/blob/main/.gitpod.Dockerfile)

<br><br>

## Road Map
- [x] Run Magento fully installed on load
- [x] Have no files marked as changed in GIT.
- [x] Install Magento SQL once on first load, delete flag to reinstall
- [x] Import staging SQL file replacing urls 
- [x] Improve config to simplify configuring the build components
- [x] Add MailPit SMTP mail catcher with zero config
- [x] Magento 2.4.6 and PHP8.2 support
- [x] Add additional SQL and config updates, Magento config for SMTP details, Algolia indexing etc. 
- [x] Accept values for Magento configuration through Gitpod ENV
<br><br>

# Credit
Based on the original Gitpod config produced by https://github.com/nemke82/magento2gitpod
