# Class: elasticsearch::plugins::head
#
#
class elasticsearch::plugins::head {
  # install the elasticsearch head plugin
  exec { 'plugin --install mobz/elasticsearch-head':
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', "${elasticsearch::es_directory}/bin" ],
    unless  => "ls ${elasticsearch::es_directory}/plugins/head",
    notify  => Service['elasticsearch'],
    require => Package["elasticsearch${::elasticsearch::version}"]
  }
}
