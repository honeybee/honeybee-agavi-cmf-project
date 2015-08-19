# vim: ts=4:sw=4:noexpandtab!:

MAKEFLAGS += --no-print-directory
PROJECT_DIR=`pwd`
LOCAL_CONFIG_SH = $(wildcard etc/local/config.sh)

ifneq "${LOCAL_CONFIG_SH}" ""
	include ${LOCAL_CONFIG_SH}
endif

ifeq "${PHP_COMMAND}" ""
	PHP_COMMAND=php
endif

PHP_ERROR_LOG=`${PHP_COMMAND} -i | grep -P '^error_log' | cut -f '3' -d " "`
ENVIRONAUT_CACHE_LOCATION=${PROJECT_DIR}/.environaut.cache
LAST_FETCH_DATE=`git reflog show -n 1 --date=iso | cut -f '1-3' -d ':'`

help:

	@PROJECT_DIR=${PROJECT_DIR} \
		ENVIRONAUT_CACHE_LOCATION=${ENVIRONAUT_CACHE_LOCATION} \
		PHP_COMMAND=${PHP_COMMAND} \
		PHP_ERROR_LOG=${PHP_ERROR_LOG} \
		LAST_FETCH_DATE=${LAST_FETCH_DATE} \
		envsubst < etc/help/Makefile.help.txt


##################
# COMMON TARGETS #
##################

autoloads:

	@${PHP_COMMAND} bin/composer.phar dump-autoload --optimize --quiet
	@echo "-> regenerated and optimized autoload files"


build-resources:

	@make link-project
	@make css
	@make js
	@echo "-> binary, css and javascript resource packages where successfully built"


cc:

	-@rm -rf app/cache/*
	@make autoloads
	@echo "-> cleared caches"


config:

	-@rm app/config/includes/*
	@bin/cli honeybee.core.util.build_config --recovery -quiet
	@echo "-> built and included configuration files"
	@make cc


environment:

	@echo "[INFO] Configuring environment of this application."
	@if [ ! -d etc/local/ ]; then mkdir -p etc/local; fi

	@vendor/bin/environaut.phar check

	@echo "[INFO] Environaut was successfully executed."


install:

	@make folders

	@echo "[INFO] Installing or updating composer locally."
	@if [ ! -f bin/composer.phar ]; \
	then \
		curl -s http://getcomposer.org/installer | ${PHP_COMMAND} -d allow_url_fopen=1 -d date.timezone="Europe/Berlin" -- --install-dir=./bin; \
	else \
		bin/composer.phar self-update; \
	fi

	@echo "[INFO] Installing vendor libraries with optimized autoloader via composer."
	@${PHP_COMMAND} -d allow_url_fopen=1 bin/composer.phar install --optimize-autoloader

	@echo "[INFO] Installing npm (node modules) into vendor/node_modules."
	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@echo "[INFO] Installing (updating) bower (clientside libraries) into vendor/bower_components."
	@cd vendor && node_modules/honeybee/node_modules/.bin/bower update --config.interactive=false

	@echo "[INFO] Downloading additional dependencies from package.txt files."
	@bin/wget_packages

	@make environment

	@make build-resources


install-production:

	@make folders

	@echo "[INFO] Installing or updating composer locally."
	@if [ ! -f bin/composer.phar ]; \
	then \
		curl -s http://getcomposer.org/installer | ${PHP_COMMAND} -d allow_url_fopen=1 -d date.timezone="Europe/Berlin" -- --install-dir=./bin; \
	else \
		bin/composer.phar self-update; \
	fi

	@echo "[INFO] Installing vendor libraries with optimized autoloader via composer."
	@${PHP_COMMAND} -d allow_url_fopen=1 bin/composer.phar install --no-dev --optimize-autoloader

	@echo "[INFO] Installing npm (node modules) into vendor/node_modules."
	@mkdir -p ./vendor/node_modules
	@npm install --prefix ./vendor

	@echo "[INFO] Installing bower (clientside libraries) into vendor/bower_components."
	@cd vendor && node_modules/honeybee/node_modules/.bin/bower install --config.interactive=false

	@echo "[INFO] Downloading additional dependencies from package.txt files."
	@bin/wget_packages

	@make environment

	@make build-resources


link-project:

	@if [ -d pub/static/modules ]; then find pub/static/modules/ -maxdepth 1 -type l -delete; fi

	@make copy-honeybee-core-modules
	@make copy-honeybee-core-themes
	@make copy-honeybee-core-schemas
	@make copy-honeybee-core-routing
	@make copy-honeybee-trellis-templates

	@make config

	@echo "[INFO] Successfully copied/linked honeybee files into the project."


migrate-all:

	@bin/cli honeybee.core.migrate.run -target all


migrate-list:

	@bin/cli honeybee.core.migrate.list


user:

	@bin/cli honeybee.system_account.user.create


reconfigure-environment:

	@echo "[INFO] Environaut cache file: ${ENVIRONAUT_CACHE_LOCATION}"

	@if [ -f "${ENVIRONAUT_CACHE_LOCATION}" ]; then rm ${ENVIRONAUT_CACHE_LOCATION} && echo "[INFO] Deleted environaut cache."; fi

	@echo "[INFO] Removed environaut cache, starting reconfiguration."

	@make environment


tail-logs:

	@tail -f "${PHP_ERROR_LOG}" app/log/*.log


css:

	@echo "[INFO] Trying to compile SCSS files from all themes and modules:"
	@bin/cli honeybee.core.util.compile_scss


js:

	@echo "[INFO] Trying to compile JS files from all modules:"
	@bin/cli honeybee.core.util.compile_js


copy-honeybee-core-modules:

	@echo "[INFO] Copying honeybee default modules into this application."
	@cp -rfHv ./vendor/honeybee/honeybee-agavi-cmf-vendor/app/modules/Honeybee_Core app/modules/
	@cp -rfHv ./vendor/honeybee/honeybee-agavi-cmf-vendor/app/modules/Honeybee_SystemAccount app/modules/


copy-honeybee-core-themes:

	@echo "[INFO] Copying honeybee default themes into this application."
	@cp -rfHv ./vendor/honeybee/honeybee-agavi-cmf-vendor/pub/static/themes/* pub/static/themes/


copy-honeybee-core-schemas:

	@echo "[INFO] Copying honeybee config schema files (XSDs) into this application."
	@cp -rfv ./vendor/honeybee/honeybee-agavi-cmf-vendor/app/config/xsd/* app/config/xsd/


copy-honeybee-core-routing:

	@echo "[INFO] Copying honeybee default module routing file into this application."
	@cp -rfv ./vendor/honeybee/honeybee-agavi-cmf-vendor/app/config/default_type_routing.xml app/config/


copy-honeybee-trellis-templates:

	@echo "[INFO] Copying honeybee default trellis templates into this application."
	@cp -rfv ./vendor/honeybee/honeybee-agavi-cmf-vendor/dev/trellis_templates dev/


folders:

	@echo "[INFO] Creating cache, log and asset folders (if missing)."
	@if [ ! -d app/cache ]; then mkdir -p app/cache; fi
	@if [ ! -d app/log ]; then mkdir -p app/log; fi
	@if [ ! -d data/assets ]; then mkdir -p data/assets; fi
	@if [ ! -d pub/static/modules-built ]; then mkdir -p pub/static/modules-built; fi
	@if [ ! -d pub/static/modules ]; then mkdir -p pub/static/modules; fi
	@chmod 755 app/cache
	@chmod 755 app/log
	@chmod 755 data/assets
	@chmod 755 pub/static/modules-built
	@chmod 755 pub/static/modules

	@if [ ! -d build/codebrowser ]; then mkdir -p build/codebrowser; fi
	@if [ ! -d build/logs ]; then mkdir -p build/logs; fi
	@if [ ! -d build/docs ]; then mkdir -p build/docs; fi
	@chmod 755 build/codebrowser
	@chmod 755 build/docs
	@chmod 755 build/logs

	@if [ -d pub/static/modules ]; then find pub/static/modules/ -maxdepth 1 -type l -delete; fi


#
#
# DEVELOPMENT TARGETS
#
#

update:

	@echo "[INFO] TRYING TO UPDATE ALL VENDOR DEPENDENCIES TO LATEST VERSIONS."

	@make folders

	@echo "[INFO] Updating composer.lock file with latest versions."
	@make update-composer-lock-file

	@echo "[INFO] Updating npm (node modules) with latest versions."
	@mkdir -p ./vendor/node_modules
	@npm update --prefix ./vendor

	@echo "[INFO] Updating bower (clientside libraries) with latest versions."
	@cd vendor && node_modules/honeybee/node_modules/.bin/bower update

	@echo "[INFO] Downloading additional dependencies from package.txt files."
	@bin/wget_packages

	@make environment

	@make build-resources


update-composer-lock-file:

	@if [ ! -f bin/composer.phar ]; then echo "Please run MAKE INSTALL first and do not run make update on non-dev machines."; fi

	@bin/composer.phar self-update

	@echo "[INFO] Updating vendor library versions in composer.lock and generating optimized autoloads."
	@${PHP_COMMAND} -d allow_url_fopen=1 bin/composer.phar update --optimize-autoloader


module:

	@make config
	@bin/cli honeybee.core.util.generate_code -skeleton honeybee_module -quiet
	@echo ""
	@echo "    You can now quickly scaffold new entity types into this"
	@echo "    module using the helper command line utility:"
	@echo ""
	@echo "    make type"
	@echo ""

type:

	@make config
	@./bin/cli honeybee.core.util.generate_code -skeleton honeybee_type -quiet
	@make config
	@echo ""
	@echo "    When you have updated your entity attributes and reference"
	@echo "    definitions you can regenerate your classes using the"
	@echo "    helper command line utility:"
	@echo ""
	@echo "    make trellis"
	@echo ""

trellis:

	@make config
	@./bin/cli honeybee.core.trellis.generate_code -quiet
	@make config

trellis-all:

	@make config
	@./bin/cli honeybee.core.trellis.generate_code -target all -quiet
	@make config

migration:

	@./bin/cli honeybee.core.migrate.create

fixture:

	@./bin/cli honeybee.core.fixture.create

#
#
# TESTING AND CODE QUALITY METRICS
#
#

php-metrics: folders

	@nice vendor/bin/phpunit tests/
	@vendor/bin/phpcs --extensions=php --standard=psr2 --report=checkstyle --report-file=build/logs/checkstyle.xml --ignore='app/cache*,*Action.class.php,*SuccessView.class.php,*InputView.class.php,*ErrorView.class.php,app/templates/*,app/config/includes/*,resources/*,migration/*,/Base/*,*Type.php,*.scss,*.css,*.js' app tests
	-@vendor/bin/phpcpd --log-pmd ./build/logs/pmd-cpd.xml app/
	-@vendor/bin/phpmd app/ xml codesize,design,naming,unusedcode --reportfile build/logs/pmd.xml

tests: folders

	@nice vendor/bin/phpunit tests/

codesniffer: folders

	@vendor/bin/phpcs --extensions=php --standard=psr2 --ignore='app/cache*,*Action.class.php,*SuccessView.class.php,*InputView.class.php,*ErrorView.class.php,app/templates/*,app/config/includes/*,resources/*,migration/*,/Base/*,*Type.php,*.scss,*.css,*.js' app tests


#
# PHONY targets @see http://www.linuxdevcenter.com/pub/a/linux/2002/01/31/make_intro.html?page=2
# vim: ts=4:sw=4:noexpandtab!:
#
.PHONY: help build-resources link-project module type trellis environment reconfigure-environment cc config install update update-composer-lock-file install-production copy-honeybee-core-modules copy-honeybee-core-themes copy-honeybee-core-schemas copy-honeybee-core-routing copy-honeybee-trellis-templates folders tests codesniffer php-metrics css js migration fixture
