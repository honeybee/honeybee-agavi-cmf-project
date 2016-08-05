# Class: elasticsearch::plugins::lang-javascript
#
#
class elasticsearch::plugins::lang_javascript {
  # install the elasticsearch lang-javascript plugin
  if $::elasticsearch::branch =~ /1\.*/ {
    $_exec = 'plugin install elasticsearch/elasticsearch-lang-javascript/2.5.0'
  }
  else {
    $_exec = "plugin install analysis-icu"
  }
  exec { '':
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/share/java/elasticsearch/bin'],
    unless  => 'ls /usr/share/java/elasticsearch/plugins/lang-javascript',
    notify  => Service['elasticsearch'],
    require => Package['elasticsearch']
  }
}
