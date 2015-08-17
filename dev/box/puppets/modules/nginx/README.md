# pp-nginx

A very slim nginx module for puppet.

* Latest Release: [![GitHub version](https://badge.fury.io/gh/DracoBlue%2Fpp-nginx.png)](https://github.com/DracoBlue/pp-nginx/releases)
* Build-Status: [![Build Status](https://travis-ci.org/DracoBlue/pp-nginx.png?branch=master)](https://travis-ci.org/DracoBlue/pp-nginx)
* Official Site: http://dracoblue.net/

pp-ningx is copyright 2014 by DracoBlue http://dracoblue.net

# Installation

Latest version from [puppet forge](http://forge.puppetlabs.com/DracoBlue/nginx):

``` console
$ puppet module install DracoBlue-nginx
```

Latest version from git.

``` console
$ cd modules
$ git clone https://github.com/DracoBlue/pp-nginx.git nginx
```

# Usage

## Example

``` ruby
# include package and server for nginx
include nginx

$server = "example.org"

# define new server (/vhost)
nginx::server { $server:
  content => "
    listen *:80;
    server_name $server;
"
}

# define a location
nginx::server::location { "assets":
  location => "~ ^/",
  server => Nginx::Server[$server],
  content => "
        root /var/www/assets/;
"
}
```

Result (`/etc/nginx/conf.d/example.org.conf`):

```
server {

    listen *:80;
    server_name example.org;

    location ~ ^/ {

        root /var/www/assets/;
    }
}
```

## Classes

There are only 3 classes in this puppet module.

* public:
  * `include nginx`: makes sure that `nginx::package` and `nginx::service` is available 
* private
  * `include nginx::package`: is loaded by the `nginx` class, to ensure that the nginx package is available on the operating system
  * `include nginx::service`: is loaded by the `nginx` class, to ensure that the nginx service control is available
  * `include nginx::base`: is used by `nginx::server::location` and `nginx::server` to ensure that the server is reloaded on file changes

## Types

See the Example at the beginning for explanation how the `nginx::server` and `nginx::server::location` type work together.

### `nginx::server`

Adds a new `server` in a file called `/etc/nginx/conf.d/$name.conf`.

``` ruby
nginx::server { "example.org":
  server => 'example.org',
  content => "
    listen *:80;
    server_name example.org;
"
}
```

See `tests/simple.example.org.pp` for more examples.

### `nginx::server::location`

Adds a `location` block definition to the given `$server`.

``` ruby
nginx::server::location { "assets":
  server => Nginx::Server['example.org'],
  location => '~ ^/assets/(.+)',
  content => "
      root /var/www;
"
}
```

See `tests/simple-locations.example.org.pp` for more examples.

### `nginx::server::location::alias`

Adds an `alias` definition to map to a `$directory` for to the given `$location`.

``` ruby
nginx::server::location::alias { "assets-directory":
  location => Nginx::Server::Location['assets'],
  directory => '/var/www/assets/$1'
}
```

See `tests/alias-location.example.org.pp` for more examples.

### `nginx::server::location::access`

Adds `allow` and `deny` definitions to a given `$location`.

``` ruby
nginx::server::location::access { "assets-directory":
  location => Nginx::Server::Location['assets'],
  allow => ["127.0.0.1", "10.10.10.0/26"],
  deny => ["192.168.0.1"]
}
```

The `access` fragment will always put `allow` definitions before `deny` definitions. If you want to have some `deny` rules
before the `allow` rules, use two `access` definitions (like in `tests/access-location-with-multiple-blocks.example.org.pp`).

See `tests/access-location.example.org.pp` for more examples.

### `nginx::server::location::auth-basic`

Adds `auth_basic` and `auth_basic_user_file` definitions to a given `$location`.

Be sure that nginx can access the absolute path given to in `$user_file`. The `$text` must not contain quotation marks (").

``` ruby
nginx::server::location::auth-basic { "assets-directory":
  location => Nginx::Server::Location['assets'],
  text => 'This is restricted',
  user_file => '/etc/nginx/.htpasswd'
}
```

See `tests/auth-basic-location.example.org.pp` for more examples.

### (private) `nginx::server::location::fragment`

This type is used within `nginx::server::location::access` and other `nginx::server::location::*` types to generate
the location fragment into the `nginx::server::location`.

Example usage (taken from `nginx::server::location::access`):

``` ruby
define nginx::server::location::access (
  $allow = [],
  $deny = [],
  $content = undef,
  $config_template = "nginx/conf.d/location/access.conf.erb",

  $location	= undef,
  $ensure = present,
  $order = "050",
) {
  validate_array($allow)
  validate_array($deny)

  nginx::server::location::fragment { "access_${name}":
    content => template($config_template),

    location => $location,
    ensure => $ensure,
    order => $order,
  }
}
```

# Run tests

``` console
$ make test
```

Hint: The tests will need sudo rights and will write into /tmp/pp-nginx-results. Every other file should not be affected.

# Changelog

* 1.2.0 (2014/03/17)
  - Changed properties for `$location` and `$server` to resources instead of strings #10
  - Removed `$server` parameter for `nginx::server::location::*` #9
* 1.1.0 (2014/03/17)
  - added `nginx::server::location::auth-basic` #8
  - added base type `nginx::server::location::fragment` #7
  - added `nginx::server::location::access` #6
  - travis now tests multiple puppet versions #5
  - `nginx::server::location::alias` adds the alias definition, to the nginx location specified #3
* 1.0.0 (2014/03/16)
  - Initial release

# License

pp-nginx is licensed under the terms of MIT.
