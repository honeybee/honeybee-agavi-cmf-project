# Class: elasticsearch::plugins::river
#
#
class elasticsearch::plugins::river {
  # install the elasticsearch river plugin
  exec { 'plugin --install elasticsearch/elasticsearch-river-couchdb/2.5.0':
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', "${elasticsearch::es_directory}/bin" ],
    unless  => "ls ${elasticsearch::es_directory}/plugins/river-couchdb",
    notify  => Service['elasticsearch'],
    require => Package["elasticsearch${::elasticsearch::version}"]
  }
}
