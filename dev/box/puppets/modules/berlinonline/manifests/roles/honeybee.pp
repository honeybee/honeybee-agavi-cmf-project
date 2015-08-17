# Class: berlinonline::roles::honeybee
# defines required manifests for deploying couchdb
class berlinonline::roles::honeybee {
  #defines required manifests for deploying couchdb
  include ::berlinonline::roles::server
  include ::berlinonline::roles::elasticsearch
  include ::berlinonline::roles::couchdb
  include ::berlinonline::roles::cms
  include ::berlinonline::roles::converjon
  include ::berlinonline::roles::devbox
  include ::elasticsearch::plugins::head
  include ::elasticsearch::plugins::icu
  class { 'berlinonline::deploy':
      stage => last,
    }
}