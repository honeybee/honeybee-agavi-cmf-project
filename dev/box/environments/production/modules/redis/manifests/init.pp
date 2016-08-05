# == Class: redis
#
# Install redis
#
# === Parameters
#
# ensure      : define version via hiera, default = present
# packagename : define for operatingsystems to make sure it may run everwhere with different names
#
class redis(
  $packagename       = 'redis',
  $ensure            = 'present',
  $listen            = ['127.0.0.1'],
  $slave_master      = '',
  $slave_mode        = false,
)
  {
  include ::redis::requirements
}
