# Templates

Put all your project's templates here. This includes the master templates for
the general layouts as well as smaller template blocks to include or embed or
even templates that should override specific view's template.

The usual lookup paths used by Honeybee are defined in the ```layer``` parts of
the ```app/config/output_types.xml``` file (or the xincluded parts). Each layer
of an layout of an output type may have different lookup paths if necessary.

Have a look at the [Honeybee templates documentation](../../docs/templates.md).

The lookup paths for template directories and twig macros are as follows:

1. ```%core.template_dir%``` which is ```app/templates```
1. ```%core.module_dir%/${module}``` which is ```app/templates/<module_name>```
1. ```%core.honeybee_template_dir%``` which is ```vendor/berlinonline/honeybee/app/templates```

The default lookup paths used in layers (for your views) are:

1. ```%core.template_dir%/modules/<module>/<locale>/<template>.<ext>```
1. ```%core.template_dir%/modules/<module>/<template>.<locale>.<ext>```
1. ```%core.template_dir%/modules/<module>/<template>.<ext>```
1. ```<action-folder>/<template>.<locale>.<ext>```
1. ```<action-folder>/<template>.<ext>```

Where ```<template``` usually is something like `Input` or ```Foo/Success```.

The template service uses a slightly different pattern that has additional
locations it looks for templates.

