<?php

use Composer\Script\Event;

class ScriptHandler
{
    const DEFAULT_HOST_NAME = 'honeybee-agavi-cmf-project.local';
    const DEFAULT_REPOSITORY_NAME = 'honeybee/honeybee-agavi-cmf-project';
    const DEFAULT_PROJECT_NAME = 'honeybee-agavi-cmf-project';

    public static function postRootPackageInstall(Event $event)
    {
        $project_path = realpath(__DIR__ . '/../../');

        $io = $event->getIO();
        $io->write('');
        $io->write('<fg=green;options=bold>Welcome to the Honeybee-Agavi CMF Project Creator</>');
        $io->write('<info>-------------------------------------------------------------------------------');
        $io->write('This package can be configured for local development or can be configured');
        $io->write('for easy installation on a preconfigured vagrant virtual machine (VM).</>');

        $io->write('');
        $io->write('Your project will now be configured for version control.');
        $vendor_package = $io->askAndValidate(
            '<options=bold>Please provide a vendor/package name: </>',
            function($input) {
                if (!preg_match('#^[\w\.\-]+/[\w\.\-]+$#', $input)) {
                    throw new Exception('Invalid vendor/package name. Format should be <vendor>/<package>');
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
            $io->write('');
            $default_url = 'https://' . $package_name . '.local';
            $hostname = $io->askAndValidate(
                'The project will be prepared in the VM at the given hostname.' . PHP_EOL .
                '<options=bold>Please provide a valid HTTPS hostname [' . $default_url . ']: </>',
                function($input) use($default_url) {
                    if (is_null($input)) {
                        return $default_url;
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
        $io->write('<fg=yellow;options=bold>configuring...</>');
        $io->write('');
        
        // Replace repository and package name
        if (isset($hostname)) {
            self::replaceStringInFiles(self::DEFAULT_HOST_NAME, $hostname, $project_path);
        }
        self::replaceStringInFiles(self::DEFAULT_REPOSITORY_NAME, $vendor_package, $project_path);
        self::replaceStringInFiles(self::DEFAULT_PROJECT_NAME, $package_name, $project_path);

        $io->write(PHP_EOL . '<fg=green;option=bold>Your project configuration is complete.</>' . PHP_EOL);
        $io->write('<info>-------------------------------------------------------------------------------</>');

        if (true === $configure_vm) {
            $io->write('<info>Before launching the VM you must commit and push changes from this repository to Github.');
            $io->write('Your repository location has already been configured to:');
            $io->write('<options=underscore>http://github.com/' .$vendor_package . '</>');
            $io->write('');
            $io->write('When you are ready you can launch the VM by executing the following commands:</>');
            $io->write('');
            $io->write('<options=bold>cd ' . $project_path . '/dev/box</>');
            $io->write('<options=bold>vagrant up</>');
            $io->write('');
        } else {
            $io->write('<info>You can now install the application by executing the following command:');
            $io->write('');
            $io->write('<options=bold>make install</>');
            $io->write('');
        }

        $io->write('<fg=green;options=bold>Thank you for using Honeybee.</>');
        $io->write('<info>You can find our support channel at <options=underscore>irc://irc.freenode.org/honeybee</>');
        $io->write('-------------------------------------------------------------------------------</info>');
        $io->write('');
    }

    protected static function replaceStringInFiles($search, $replacement, $path, array $exclude_paths = array())
    {
        $objects = new RecursiveIteratorIterator(
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

        foreach($objects as $name => $object) {
            if($object->isFile() && is_writable($object->getRealPath())) {
                $file_contents = file_get_contents($object->getRealPath());
                $file_contents = str_replace($search, $replacement, $file_contents);
                file_put_contents($object->getRealPath(), $file_contents);
            }
        }
    }
}

