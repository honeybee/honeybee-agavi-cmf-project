<?php

$application_dir = @$application_dir ?: realpath(__DIR__ . '/../');
require(
    realpath(
        $application_dir . '/vendor/honeybee/honeybee-agavi-cmf-vendor/pub/index.php'
    )
);
