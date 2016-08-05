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
  include ::berlinonline::certs
  include ::ssh::server
  include ::ssh::client
  include ::php
  include ::php::modules::cli
  include ::php::modules::fpm
  include ::local_conf
  include ::berlinonline::packages::augeas
  hiera_include('berlinonline::additional_roles')
}
