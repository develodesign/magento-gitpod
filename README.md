# Mage-OS Gitpod Cloud Development Environment

## Introduction
This repository serves as a springboard to launch fully-configured Mage-OS 2 CDE Cloud Development Environments using Gitpod.
<br><br>

## Getting Started
Register for a free Gitpod Account [https://gitpod.io](https://gitpod.io).
Fork this repository and launch your Mage-OS CDE workspace with a single click.
<br><br>



## Zero config required development tools
**Development Toolkit:** Includes ready to go tools that make you a super powered developer.

**MailPit :**
email catching and debugging

**Tab nine :**
A.I autocomplete code tool

**Cypress :**
A great testing tool

**Xdebug :**
PHP debugger ready to go

**N98-Magerun :**
email catching and debugging
<br><br>
 
## How to Use
**Fork the Repository:**
Fork this repository to your GitHub account.

**Open in Gitpod:**
Click the Gitpod button on your forked repository to launch the development environment.

**Start Coding:**
Once the environment is ready, you can start coding immediately with Mage-OS 2.
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

Jumpstart your Mage-OS 2 development with the efficiency and flexibility of a cloud-based environment. Try it now and experience a streamlined development workflow that lets you focus on coding, not configuration.

## Learn More
[Click here to Learn more about Gitpod for Mage-OS 2 on our Free Teachable Course](https://develo.teachable.com/p/mastering-gitpod-for-Mage-OS-2-development)
<br><br>

## Installing an existing database
- Uncomment and complete the code [here](https://github.com/develodesign/magento-gitpod/blob/0880b246b9392d07d3655c740ba2f59376fd68f2/gitpod/m2-install.sh#L28) to have the script import an existing Mage-OS 2 database. 
- Replace ```staging-domain.com``` in the file with your Mage-OS 2 url, this will be replaced with the current gitpod workspace URL before import.
- Compress your .sql file and place into the gitpod folder as ```Mage-OS-db.sql.zip```
- Set INSTALL_Mage-OS = No in the [.gitpod.Dockerfile](https://github.com/develodesign/magento-gitpod/blob/main/.gitpod.Dockerfile)

<br><br>

## Road Map
- [x] Run Mage-OS fully installed on load
- [x] Have no files marked as changed in GIT.
- [x] Install Mage-OS SQL once on first load, delete flag to reinstall
- [x] Import staging SQL file replacing urls 
- [x] Improve config to simplify configuring the build components
- [x] Add MailPit SMTP mail catcher with zero config
- [x] Mage-OS 2.4.6 and PHP8.2 support
- [x] Add additional SQL and config updates, Mage-OS config for SMTP details, Algolia indexing etc. 
- [x] Accept values for Mage-OS configuration through Gitpod ENV
<br><br>

# Credit
Based on the original Gitpod config produced by https://github.com/nemke82/Mage-OS2gitpod
