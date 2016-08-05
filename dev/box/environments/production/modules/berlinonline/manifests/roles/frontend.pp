# Class: berlinonline::roles::frontend
#
# role for berlinonline frontends
class berlinonline::roles::frontend {
  include ::berlinonline::roles::server
  include ::berlinonline::roles::elasticsearch
  include ::berlinonline::roles::application
  include ::berlinonline::roles::converjon
  include ::berlinonline::roles::devbox
  include ::elasticsearch::plugins::head
  include ::elasticsearch::plugins::icu

  class { 'composer':
    auto_update => true
  }

  class { 'berlinonline::deploy':
  }
}
