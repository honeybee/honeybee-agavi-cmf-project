# Class: elasticsearch::validator
#
#
class elasticsearch::validator {
  case $::operatingsystem {
    'OpenSuSE': {
      unless $::elasticsearch::branch =~ /2\.3|1\.5/ {
        fail ("${::elasticsearch::branch} branch of Elasticsearch currently not supported. Supported Branches are : 2.3 and 1.5")
      }
    }
  }
}
