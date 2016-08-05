# Class: converjon::nodejs
#
#
class converjon::nodejs(
)
{
  package { 'nodejs':
      ensure => installed,
  }
}
