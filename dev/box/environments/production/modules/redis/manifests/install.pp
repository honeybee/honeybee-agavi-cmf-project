class redis::install{
  package { $::redis::packagename :
    ensure => $::redis::ensure
  }
  include ::redis::service
}
