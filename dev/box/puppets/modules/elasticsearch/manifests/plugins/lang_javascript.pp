# Class: elasticsearch::plugins::lang-javascript
#
#
class elasticsearch::plugins::lang_javascript {
  # install the elasticsearch lang-javascript plugin
  exec { 'plugin --install elasticsearch/elasticsearch-lang-javascript/2.5.0':
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', "${elasticsearch::es_directory}/bin" ],
    unless  => "ls ${elasticsearch::es_directory}/plugins/lang-javascript",
    notify  => Service['elasticsearch'],
    require => Package["elasticsearch${::elasticsearch::version}"]
  }
}
