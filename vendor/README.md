# Vendor Libraries and Package Managers

Honeybee projects use many different libraries. Multipe package managers are in
use to handle the dependencies between the necessary libraries and their
dependencies.

## Composer

The main package manager for Honeybee is [Composer](https://getcomposer.org).
All PHP libraries should be added to the ```composer.json``` file in the root
cms directory. It is advisable to commit the ```composer.lock``` file so other
developers get the exact same versions of libraries. The version constraints can
be updated by running ```make update``` or by updating single libraries via
running ```bin/composer.phar update library/name```.

## NPM

Honeybee uses [npm](https://www.npmjs.org/) to handle `nodejs` libraries and
their dependencies in the ```vendor/package.json``` file. Honeybee uses
```r.js``` to compile and minify javascript and css files and installs
```bower``` via npm.

## Bower

Honeybee uses [Bower](http://bower.io) to handle clientside libraries and their
dependencies. All javascript, css, scss and other clientside assets like
webfonts or icon sets should be handled via bower or can be downloaded and put
into the ```pub/static``` or module's ```resources``` folders directly. The
```vendor/bower.json``` file contains all the project's clientside deps.

## Wget

Honeybee uses a simple line based text format to handle dependencies that are
not covered by the other package managers. At the moment this means downloading
Apache Tika to read metadata from asset files (like images or PDFs). The
```vendor/package.txt``` file may contain all other necessary files that should
be downloaded when running ```make install``` or ```make update```.

