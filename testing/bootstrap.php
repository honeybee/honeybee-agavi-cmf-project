<?php

$app_dir = dirname(__DIR__);

require($app_dir . str_replace('/', DIRECTORY_SEPARATOR, '/vendor/autoload.php'));

$app_autoload_include = $app_dir . str_replace('/', DIRECTORY_SEPARATOR, '/app/config/includes/autoload.php');
if (is_readable($app_autoload_include)) {
    require($app_autoload_include);
}
