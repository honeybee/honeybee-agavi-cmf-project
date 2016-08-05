# Class: elasticsearch::plugins::head
#
#
class elasticsearch::plugins::icu(
  $version = '2.5.0'
)
{
  if $::elasticsearch::branch =~ /1\.*/ {
    $_exec = "plugin --install elasticsearch/elasticsearch-analysis-icu/${$elasticsearch::plugins::icu::version}"
  }
  else {
    $_exec = "plugin install analysis-icu"
  }
  exec { $_exec:
    path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/share/java/elasticsearch/bin/' ],
    unless  => "ls /usr/share/java/elasticsearch/plugins/analysis-icu",
    notify  => Service['elasticsearch'],
    require => Package['elasticsearch']
  }
}
