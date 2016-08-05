# defined type for berlinonline multi_package macro
define basics::multi_package ($packagelist = $packagelist) {
  package { $packagelist:
    ensure => installed,
  }
}