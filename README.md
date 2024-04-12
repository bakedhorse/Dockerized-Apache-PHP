# Dockerized Apache and PHP (this-could've-been-done-better-but-it-works-edition)
This dockerfile uses Ubuntu:latest and installs apache2 and php. All in the same container. Has a "modular" apache2 module and php extensions install.

### Install
```
* git clone https://github.com/bakedhorse/Dockerized-Apache-PHP
* cd Dockerized-Apache-PHP
* docker compose build
* docker compose up -d
```
### Configuration
A "conf" folder will be created. This will contain apache2's and php's config folders. Along with "www" for websites' folders.
The container should automatically declare www-data as owner of any file within "www" folder.

### Enabling apache2 modules and installing php extensions
Two text files exist for enabling apache2 modules and installing php extensions.
These two files are named "apache2-modules.txt" and "php-extensions.txt".

When adding a new module or extension, you need to re-run "docker compose build" to add the new modules and/or extensions to the container.
### Why is this project's code doo-doo?
I just wanted something that functioned and I can properly modify without jumping through thousands of loops.
It could've been done better. But it works for what I need it for.
