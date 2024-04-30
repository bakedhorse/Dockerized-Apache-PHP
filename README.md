# Dockerized Apache and PHP (this-could've-been-done-better-but-it-works-edition)
Dockerfile that dockerizes Apache and PHP in one container using Ubuntu.
Has the ability to add packages and modify apache2 modules, confs, and sites.

### Install
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

### Modifying apache2
Add any modules, confs, and/or sites to the corresponding text files.
```
* nano modules/apache2-modules.txt
* nano modules/apache2-confs.txt
* nano modules/apache2-sites.txt
```
These will be applied every time the docker starts up with ```docker compose up```. Any custom modules or confs not in apache2 by default must be added either through the ```php-extensions.txt``` or ```additional-packages.txt```, or manually through the ```conf``` folder.

### Configuration
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
Any modifications that require modules, confs, or sites to be enabled/disabled, or install php extensions should be done too. [Ref#1](#modifying-apache2) [Ref#2](#install) 

### Why is this project's code doo-doo?
I just wanted something that functioned and I can easily modify without jumping through thousands of loops.
It could've been done better. But it works for what I need it for.
