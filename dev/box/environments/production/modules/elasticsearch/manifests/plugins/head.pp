# Class: elasticsearch::plugins::head
#
#
class elasticsearch::plugins::head {
  # install the elasticsearch head plugin
  if $::elasticsearch::branch =~ /1\.*/ {
    $_exec = 'plugin -install mobz/elasticsearch-head/1.x'
  }
  else {
    $_exec = 'plugin install mobz/elasticsearch-head'
  }
  exec { $_exec:
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/share/java/elasticsearch/bin' ],
    unless  => 'ls /usr/share/java/elasticsearch/plugins/head',
    notify  => Service['elasticsearch'],
    require => Package['elasticsearch']
  }
}
