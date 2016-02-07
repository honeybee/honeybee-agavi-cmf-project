define basics::multi_package ($packagelist = $packagelist) {
   package { $packagelist:
      ensure => installed,
   }
}