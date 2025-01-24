# Dockerized Apache and PHP 
* (this-could've-been-done-better-but-it-works-edition)

## NOTICE: I am currently migrating from apache2 to nginx. This means this project won't be actively supported anymore. However the code will be re-used (for now) in the [nginx](https://github.com/bakedhorse/Dockerized-Nginx) version.

Dockerfile that dockerizes Apache and PHP in one container using Ubuntu.
Has the ability to add packages and modify apache2 modules, confs, and sites.

## Install
Clone the files from the github and go into the folder it creates.
```
* git clone https://github.com/bakedhorse/Dockerized-Apache-PHP
* cd Dockerized-Apache-PHP
```
Modify PHP extensions and additional packages before building, if you want to add any php extensions and/or additional packages for apache2.
(If you update these files in the future, you must do ```docker compose build``` afterwards otherwise any new packages will not be installed)
```
* nano modules/php-extensions.txt
* nano modules/additional-packages.txt
```
Build and run the docker compose to generate 
```
* docker compose build
* docker compose up
```

Once you do that, you should be setup to go. If you want to continue adding modules, confs, and sites to apache2; Continue reading on.

## Configuration
### Enable/Disable apache2 mods, confs, and sites
Add any modules, confs, and/or sites to the corresponding text files.
```
* nano modules/apache2-modules.txt
* nano modules/apache2-confs.txt
* nano modules/apache2-sites.txt
```
These will be applied every time the docker starts up with ```docker compose up```. Any custom modules or confs not in apache2 by default must be added either through the ```php-extensions.txt``` or ```additional-packages.txt```, or manually through the ```conf``` folder.

### Configuration Folders
All files for apache2 are located in
```
* conf/apache2
```
Files for the website are located 
```
* conf/www
```
Files for php are located
```
* conf/php
```
Any modifications that require modules, confs, or sites to be enabled/disabled, or install php extensions should be done too. [Ref#1](#enabledisable-apache2-mods-confs-and-sites) [Ref#2](#install) 

## Keeping up to date/PHP major versions
Currently the docker's ```app.sh``` file automatically does packages updates on start up. This is the current solution for keeping servers up to date. However this may change. <br>
* Apache2 and PHP uses a ppa repo to have the latest version downloaded.<br>
* Changing the major PHP version is doable in ```.env```, however requires ```docker compose build``` to be done. Along with the PHP config files needing to be re-done due to PHP having separate folders for their major versions.<br>
```Note: PHP8.1 will be replaced with 8.2 or later in the future due to its eventual depreciation. You may use 8.2 or later versions if your use case supports it.```
## FAQ
### Do you plan to make this a useable Docker image?
TL;DR At the current moment, No. <br>
* The project requires a lot of re-building if you aren't using the stock apache2 and php, with the already provided extensions and modules. This is due to php extensions and additional packages; Due to this limitation, it's not a desire for my own personal use case.
* I haven't developed a docker image before, so this would a first for me. Once again, I'm not desiring to do this.
* I don't know all the legal boundaries of this, it's good enough as a small project you compile yourself. Rather than hosting an image with pre-packed apache2 and php, along with other packages, the user themselves builds the image on their own machine which they download the assets off of their own developers' sites.
### Are you planning on using Alpine?
* Initially the project was planned to use Alpine. However due to package limitations along with how different configuration was on alpine for apache2 and php, Ubuntu was decided instead. When it comes to the file size of the docker itself, it's at least 400-500mb with Ubuntu. Which sucks because I wanted to save both performance and storage with Alpine.
* In the future, I will look into porting over the ```Dockerfile``` and scripts to use Alpine instead. But for now, Ubuntu works fine.
### Why is this project's code doo-doo?
* I just wanted something that functioned and I can easily modify without jumping through thousands of loops.
It could've been done better. But it works for what I need it for.
