<?php

// application directory must be readable
$app_dir = getenv('APPLICATION_DIR');
if ($app_dir === false) {
    if (!putenv('APPLICATION_DIR=' . realpath(__DIR__ . '/../'))) {
        error_log('Application directory could not be set via putenv.');
        throw new \Exception('Application directory could not be set.');
    }
}

$app_dir = getenv('APPLICATION_DIR');
if ($app_dir === false
    || realpath($app_dir) === false
    || !is_readable($app_dir)
) {
    error_log('No application directory configured for application.');
    throw new \Exception('No application directory configured for application.');
}

// bootstrap file must be readable
$bootstrap_file = getenv('BOOTSTRAP_PHP_FILE');
if ($bootstrap_file === false) {
    putenv('BOOTSTRAP_PHP_FILE=' . realpath(__DIR__ . '/../app/bootstrap.php'));
}

$bootstrap_file = getenv('BOOTSTRAP_PHP_FILE');
if (realpath($bootstrap_file) === false || !is_readable($bootstrap_file)) {
    error_log('No bootstrap file configured for application.');
    throw new \Exception('No bootstrap file configured for application.');
}

$index_php_file = getenv('INDEX_PHP_FILE');
if ($index_php_file === false) {
    $index_php_file = $app_dir . '/vendor/honeybee/honeybee-agavi-cmf-vendor/pub/index.php';
}

// include honeybee index.php file
require($index_php_file);

