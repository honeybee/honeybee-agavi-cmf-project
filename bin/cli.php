<?php

$application_dir = @$application_dir ?: realpath(__DIR__ . '/../');
require($application_dir . '/vendor/honeybee/honeybee-agavi-cmf-vendor/bin/cli.php');
