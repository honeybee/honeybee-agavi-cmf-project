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

        // Replace repository and package name
        if (isset($hostname)) {
            self::replaceStringInFiles(self::DEFAULT_HOST_NAME, $hostname, $project_path);
        }
        self::replaceStringInFiles(self::DEFAULT_REPOSITORY_NAME, $vendor_package, $project_path);
        self::replaceStringInFiles(self::DEFAULT_PROJECT_NAME, $package_name, $project_path);

        // Remove .git files if present
        // self::deleteGitFiles($project_path . DIRECTORY_SEPARATOR . '.git');

        $io->write('<fg=green;options=bold>Your project configuration is complete.</>');
        $io->write('<info>--------------------------------------------------------------------------------------------');

        if (true === $configure_vm) {
            $io->write('<fg=green;options=reverse>Before launching the VM you must commit and push this repository to Github.</>');
            $io->write('');
            $io->write('Please execute the following git commands as detailed here:');
            $io->write('<options=underscore>https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line</>');
            $io->write('');
            $io->write('<options=bold>git init</>');
            $io->write('<options=bold>git add .</>');
            $io->write('<options=bold>git commit -m "Initialising project"</>');
            $io->write('<options=bold>git remote add origin git@github.com:' . $vendor_package . '.git</>');
            $io->write('<options=bold>git push origin master</>');
            $io->write('');
            $io->write('When the repository is ready, you can launch the VM by executing the following commands:');
            $io->write('');
            $io->write('<options=bold>cd ' . $project_path . '/dev/box</>');
            $io->write('<options=bold>vagrant up</> <comment># this may take a while, time to grab a coffee</comment>');
            $io->write('');
            $io->write('Once the VM is up and running you can complete installation using the following commands:');
            $io->write('');
            $io->write('<options=bold>vagrant ssh</>');
            $io->write('<options=bold>cd /srv/www/' . $hostname . '</>');
            $io->write('<options=bold>make install</>');
        } else {
            $io->write('You can now install the application by executing the following command:');
            $io->write('');
            $io->write('<options=bold>make install</>');
            $io->write('');
            $io->write('Don\'t forget to setup your git repository as detailed here:');
            $io->write('<options=underscore>https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line</>');
        }

        $io->write('');
        $io->write('Further Honeybee information and support can be found here:');
        $io->write('Installation documentation: <options=underscore>https://github.com/honeybee/honeybee-agavi-cmf-project</>');
        $io->write('Cookbook & demo project: <options=underscore>https://github.com/honeybee/honeybee-agavi-cmf-demo/cookbook</>');
        $io->write('IRC support and feedback: <options=underscore>irc://irc.freenode.org/honeybee</>');
        $io->write('--------------------------------------------------------------------------------------------</info>');
        $io->write('<fg=green;options=bold>Thank you for using Honeybee.</>');
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

        foreach ($objects as $name => $object) {
            if ($object->isFile() && is_writable($object->getRealPath())) {
                $file_contents = file_get_contents($object->getRealPath());
                $file_contents = str_replace($search, $replacement, $file_contents);
                file_put_contents($object->getRealPath(), $file_contents);
            }
        }
    }

    protected static function deleteGitFiles($path)
    {
        if (is_writable($path)) {
            $files = array_diff(scandir($path), array('.','..'));
            foreach ($files as $file) {
                (is_dir("$path/$file")) ? self::deleteGitFiles("$path/$file") : unlink("$path/$file");
            }
            rmdir($path);
        }
    }
}
