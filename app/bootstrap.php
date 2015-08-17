<?php

/*
 * you may register special autoloaders here
 */

// get application directory
$application_dir = getenv('APPLICATION_DIR');
if ($application_dir === false) {
    throw new \Exception('APPLICATION_DIR not set. Bootstrap aborted.');
}

// bootstrap honeybee
require($application_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/honeybee/honeybee-agavi-cmf-vendor/app/bootstrap.php'));

/*
 * you may set additional settings here:
 * AgaviConfig::set('omg', 'yeah');
 */

date_default_timezone_set('Europe/Berlin');

