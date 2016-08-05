class redis::requirements {
    case $::operatingsystem {
        'openSuSE': {
            zypprepo { 'Database':
                baseurl      =>"http://download.opensuse.org/repositories/server:/database/openSUSE_${::operatingsystemrelease}",
                enabled      => 1,
                autorefresh  => 1,
                name         => 'Database',
                gpgcheck     => 0,
                priority     => 98,
                keeppackages => 1,
                type         => 'rpm-md',
                before       => Package[redis]
            }
            include redis::install
        }
        default: { fail("This module for Redis is not supported on ${::operatingsystem}") }
    }
}
