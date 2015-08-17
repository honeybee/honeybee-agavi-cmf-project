# Class: elasticsearch::plugins::head
#
#
class elasticsearch::plugins::icu(
   $version = '2.5.0'
   ) {
   # install the elasticsearch icu analysis plugin
   exec { "plugin install elasticsearch/elasticsearch-analysis-icu/${$elasticsearch::plugins::icu::version}":
       path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', "${elasticsearch::es_directory}/bin"],
       unless  => "ls ${elasticsearch::es_directory}/plugins/analysis-icu",
       notify  => Service['elasticsearch'],
       require => Package["elasticsearch${::elasticsearch::version}"]
   }
}
