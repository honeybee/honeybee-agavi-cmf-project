# Class: berlinonline::roles:defines general resources needed for all servers
#
class berlinonline::roles::server {
  # defines general resources needed for all servers
  include ::berlinonline
  include ::basics
  include ::basics::packages
  include ::basics::users
  include ::berlinonline::aliases
  include ::berlinonline::packages
  include ::berlinonline::update
  include ::berlinonline::motd
  include ::berlinonline::sudos
  include ::ssh::server
  include ::php
  include ::php::modules::cli
  include ::php::modules::fpm
  hiera_include('berlinonline::additional_roles')
}
