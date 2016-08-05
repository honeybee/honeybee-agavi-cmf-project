<?php

namespace HoneybeeExtensions\Composer;

use Composer\Script\Event;
use RecursiveIteratorIterator;
use RecursiveCallbackFilterIterator;
use RecursiveDirectoryIterator;
use Exception;

class ProjectHandler
{
    const DEFAULT_HOST_NAME = 'honeybee-agavi-cmf-project.local';
    const DEFAULT_REPOSITORY_NAME = 'honeybee/honeybee-agavi-cmf-project';
    const DEFAULT_PROJECT_NAME = 'honeybee-agavi-cmf-project';

    protected static function getProjectPath(Event $event)
    {
        return realpath($event->getComposer()->getConfig()->get('vendor-dir') . DIRECTORY_SEPARATOR . '..');
    }

    public static function postRootPackageInstall(Event $event)
    {
        $project_path = self::getProjectPath($event);

        $io = $event->getIO();
        $io->write('');
        $io->write('<fg=green;options=bold>Welcome to the Honeybee-Agavi CMF Project Creator</>');
        $io->write('<info>--------------------------------------------------------------------------------------------');
        $io->write('This package can be configured for local development or can be configured');
        $io->write('for easy installation on a preconfigured vagrant virtual machine (VM).</>');
        $io->write('');
        $io->write('Your project will now be configured for version control.');
        $vendor_package = $io->askAndValidate(
            '<options=bold>Please provide a Github <user>/<repository> name: </>',
            function($input) {
                if (!preg_match('#^[\w\.\-]+/[\w\.\-]+$#', $input)) {
                    throw new Exception('Invalid repository name. Format should be <user>/<repository>');
                } else {
                    return $input;
                }
            },
            5
        );
        $package_name = substr($vendor_package, strpos($vendor_package, '/') + 1);

        $io->write('');
        $io->write('This project can be automatically provisoned on a preconfigured virtual machine.');
        $configure_vm = $io->askConfirmation('<options=bold>Would you like to configure a VM? [y,N]: </>', false);
        if (true === $configure_vm) {
            $default_url = 'https://' . $package_name . '.local';
            $io->write('');
            $io->write('The project will be prepared in the VM at the given hostname.');
            $hostname = $io->askAndValidate(
                '<options=bold>Please provide a valid HTTPS hostname [' . $default_url . ']: </>',
                function($input) use($default_url) {
                    if (is_null($input)) {
                        return parse_url($default_url, PHP_URL_HOST);
                    } elseif (!filter_var($input, FILTER_VALIDATE_URL) || !preg_match('#^https.+#', $input)) {
                        throw new Exception('Hostname provided should be a valid HTTPS hostname');
                    } else {
                        return parse_url($input, PHP_URL_HOST);
                    }
                },
                5
            );
        }

        $io->write('');
        $io->write('<fg=yellow>');
        $io->write("                      // \ ");
        $io->write("                      \\\\_/ // ");
        $io->write("    ''-.._.-''-.._.. -(||)(')");
        $io->write("                      '''");
        $io->write('Please wait while your project is configured...</>');
        $io->write(PHP_EOL);

        // Replace host, repository and package name
        if (isset($hostname)) {
            $replacements[self::DEFAULT_HOST_NAME] = $hostname;
        }
        $replacements[self::DEFAULT_REPOSITORY_NAME] = $vendor_package;
        $replacements[self::DEFAULT_PROJECT_NAME] = $package_name;
        self::replaceStringInFiles($replacements, $project_path);

        $io->write('<fg=green;options=bold>Your project configuration is complete.</>');
        $io->write('<info>--------------------------------------------------------------------------------------------');

        if (true === $configure_vm) {
            $io->write('<fg=green;options=reverse>Before launching the VM you must create and push this repository to Github.</>');
            $io->write('');
            $io->write('Please execute the following git commands as detailed here:');
            $io->write('<options=underscore>https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line</>');
            $io->write('');
            $io->write('<options=bold>git init</>');
            $io->write('<options=bold>git add .</>');
            $io->write('<options=bold>git commit -m "Initialising project"</>');
            $io->write('<options=bold>git remote add origin git@github.com:' . $vendor_package . '.git</>');
            $io->write('<options=bold>git push -u origin master</>');
            $io->write('');
            $io->write('When the repository is ready, you can launch the VM by executing the following commands:');
            $io->write('');
            $io->write('<options=bold>cd ' . $project_path . '/dev/box</>');
            $io->write('<options=bold>vagrant plugin install vagrant-vbguest</> <comment># required plugin</comment>');
            $io->write('<options=bold>vagrant up</> <comment># this may take a while, time to grab a coffee</comment>');
            $io->write('');
            $io->write('Once the VM is up and running you can complete installation using the following commands:');
            $io->write('');
            $io->write('<options=bold>vagrant ssh</>');
            $io->write('<options=bold>cd /srv/www/' . $hostname . '</>');
            $io->write('<options=bold>composer install</>');
            $io->write('<options=bold>sudo service nginx restart</>');
        } else {
            $io->write('You can now install the application by executing the following command:');
            $io->write('');
            $io->write('<options=bold>composer install</>');
            $io->write('');
            $io->write('Don\'t forget to setup your git repository as detailed here:');
            $io->write('<options=underscore>https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line</>');
        }

        $io->write('');
        $io->write('Further Honeybee information and support can be found here:');
        $io->write('Installation documentation: <options=underscore>https://github.com/' . self::DEFAULT_REPOSITORY_NAME . '</>');
        $io->write('Demo project & Cookbook: <options=underscore>https://github.com/honeybee/honeybee-agavi-cmf-demo/wiki</>');
        $io->write('IRC support and feedback: <options=underscore>irc://irc.freenode.org/honeybee</>');
        $io->write('--------------------------------------------------------------------------------------------</info>');
        $io->write('<fg=green;options=bold>Thank you for using Honeybee.</>');
        $io->write('');
    }

    public static function call(Event $event)
    {
        $io = $event->getIO();
        $args = ScriptToolkit::processArguments($event->getArguments());
        if (!isset($args['route'])) {
            throw new Exception('"route" argument is required');
        }

        $cmd_line = [ 'bin/cli', $args['route'] ];
        unset($args['route']);
        foreach ($args as $arg => $val) {
            $cmd_line[] = '-' . $arg;
            $cmd_line[] = $val;
        }

        $process = ScriptToolkit::createProcess(
            implode(' ', $cmd_line),
            ScriptToolkit::getProjectPath($event)
        );

        $process->run(function ($type, $buffer) use ($io) {
            $io->write($buffer, false);
        });
    }

    public static function createUser(Event $event)
    {
        self::call(
            new Event(
                $event->getName(),
                $event->getComposer(),
                $event->getIO(),
                $event->isDevMode(),
                [ '-route=honeybee.system_account.user.create' ]
            )
        );
    }

    public static function preInstall(Event $event)
    {
        $io = $event->getIO();
        self::makeDirectories($event);
    }

    public static function postInstall(Event $event)
    {
        $io = $event->getIO();
        $project_path = ScriptToolkit::getProjectPath($event);
        $install_app = $io->askConfirmation('<options=bold>Would you also like to install the project? [y,N]: </>', false);
        if ($install_app) {
            self::installProject($event);
        }
    }

    public static function installProject(Event $event)
    {
        $io = $event->getIO();
        $io->write('-> installing project');
        $project_path = ScriptToolkit::getProjectPath($event);

        $io->write('-> installing node modules');
        $process = ScriptToolkit::createProcess('npm install --prefix vendor', $project_path);
        $process->run(function ($type, $buffer) use ($io) {
            $io->write($buffer, false);
        });

        $io->write('-> running bower install');
        $process = ScriptToolkit::createProcess(
            'node_modules/honeybee/node_modules/.bin/bower install --config.interactive=false',
            $project_path . '/vendor'
        );
        $process->run(function ($type, $buffer) use ($io) {
            $io->write($buffer, false);
        });

        $io->write('-> getting packages');
        $process = ScriptToolkit::createProcess('bin/wget_packages', $project_path);
        $process->run(function ($type, $buffer) use ($io) {
            $io->write($buffer, false);
        });

        self::buildAssets($event);
    }

    public static function buildAssets(Event $event)
    {
        $io = $event->getIO();
        $io->write('-> building binary, css and javascript asset packages');
        self::linkProject($event);
        self::makeCss($event);
        self::makeJs($event);
    }

    public static function linkProject(Event $event)
    {
        $io = $event->getIO();
        $io->write('-> copying and linking Honeybee files into project');
        $project_path = self::getProjectPath($event);

        $modules_path = $project_path . DIRECTORY_SEPARATOR . 'pub/static/modules';
        $files = array_diff(scandir($modules_path), [ '.', '..' ]);
        foreach ($files as $file) {
            if (is_link($file)) {
                unlink($file);
            }
        }

        $io->write('-> copying Honeybee default modules');
        ScriptToolkit::copyDirectory(
            $project_path . '/vendor/honeybee/honeybee-agavi-cmf-vendor/app/modules/Honeybee_Core',
            $project_path . '/app/modules/Honeybee_Core'
        );
        ScriptToolkit::copyDirectory(
            $project_path . '/vendor/honeybee/honeybee-agavi-cmf-vendor/app/modules/Honeybee_SystemAccount',
            $project_path . '/app/modules/Honeybee_SystemAccount'
        );

        $io->write('-> copying Honeybee default themes');
        ScriptToolkit::copyDirectory(
            $project_path . '/vendor/honeybee/honeybee-agavi-cmf-vendor/pub/static/themes',
            $project_path . '/pub/static/themes'
        );

        $io->write('-> copying Honeybee configuration schema files');
        ScriptToolkit::copyDirectory(
            $project_path . '/vendor/honeybee/honeybee-agavi-cmf-vendor/app/config/xsd',
            $project_path . '/app/config/xsd'
        );

        $io->write('-> copying Honeybee default module resource routing file');
        copy(
            $project_path . '/vendor/honeybee/honeybee-agavi-cmf-vendor/app/config/default_resource_routing.xml',
            $project_path . '/app/config/default_resource_routing.xml'
        );

        $io->write('-> copying Honeybee default Trellis templates');
        ScriptToolkit::copyDirectory(
            $project_path . '/vendor/honeybee/honeybee-agavi-cmf-vendor/dev/trellis_templates',
            $project_path . '/dev/trellis_templates'
        );

        ConfigurationHandler::buildConfig($event);
    }

    public static function makeCss(Event $event)
    {
        $io = $event->getIO();
        $io->write('-> compiling SCSS files from all themes and modules');
        $project_path = ScriptToolkit::getProjectPath($event);

        $process = ScriptToolkit::createProcess('bin/cli honeybee.core.util.compile_scss', $project_path);
        $process->run(function ($type, $buffer) use ($io) {
            $io->write($buffer, false);
        });
    }

    public static function makeJs(Event $event)
    {
        $io = $event->getIO();
        $io->write('-> compiling JS files from all modules');
        $project_path = ScriptToolkit::getProjectPath($event);

        $process = ScriptToolkit::createProcess('bin/cli honeybee.core.util.compile_js', $project_path);
        $process->run(function ($type, $buffer) use ($io) {
            $io->write($buffer, false);
        });
    }

    public static function makeDirectories(Event $event)
    {
        $io = $event->getIO();
        $io->write('-> initialising directories');
        $project_path = self::getProjectPath($event);
        $paths = [
            'app/cache',
            'app/log',
            'data/files',
            'data/temp_files',
            'data/process_states',
            'pub/static/modules-built',
            'pub/static/modules',
            'build/codebrowser',
            'build/logs',
            'build/docs',
            'vendor/node_modules',
            'etc/local'
        ];

        // pre-install manual mkdir
        foreach ($paths as $path) {
            $target = $project_path . DIRECTORY_SEPARATOR . $path;
            if (!is_dir($target)) {
                mkdir($target, 0755, true);
            }
        }

        // @todo remove pub/static/modules symlinks here?
    }

    /*
     * This method lives here so it can be used by create-project prior to dependencies being installed
     */
    protected static function replaceStringInFiles(array $replacements, $path, array $exclude_paths = [])
    {
        $iterator = new RecursiveIteratorIterator(
            new RecursiveCallbackFilterIterator(
                new RecursiveDirectoryIterator($path, RecursiveDirectoryIterator::SKIP_DOTS),
                function ($current) use ($path, $exclude_paths) {
                    if ($current->isDir()) {
                        foreach ($exclude_paths as $exclusion) {
                            $real_exclusion = $path . DIRECTORY_SEPARATOR . $exclusion;
                            if ($current->getRealPath() == $real_exclusion) {
                                return false;
                            }
                        }
                    }
                    return true;
                }
            ),
            RecursiveIteratorIterator::SELF_FIRST
        );

        foreach ($iterator as $name => $object) {
            if ($object->isFile() && is_writable($object->getRealPath())) {
                $file_contents = file_get_contents($object->getRealPath());
                // To avoid renaming collisions we rename to uniqids first, then replace
                foreach ($replacements as $search => $replace) {
                    $uniqids[$search] = $unqid = uniqid('projecthandler::');
                    $file_contents = str_replace($search, $unqid, $file_contents);
                }
                foreach ($replacements as $search => $replace) {
                    $file_contents = str_replace($uniqids[$search], $replace, $file_contents);
                }
                file_put_contents($object->getRealPath(), $file_contents);
            }
        }
    }
}
