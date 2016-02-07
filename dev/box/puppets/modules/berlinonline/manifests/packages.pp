# Class: berlinonline::packages
#
#
class berlinonline::packages(
  $avahi            = '',
  $nfs_server       = ''
  )
{
  realize Package[bzip2]
  realize Package[curl]
  realize Package[less]
  realize Package[lsof]
  realize Package[patch]
  realize Package[rsync]
  realize Package[screen]
  realize Package[smartmontools]
  realize Package[tree]
  realize Package[unzip]
  realize Package[zip]
  realize Package[openssl]
  realize Package[git]
  realize Package[vim-data]
  realize Package[rubygem-sass]
  realize Package[bash-completion]
  realize Package[systemd-bash-completion]
  realize Package[make]
  realize Package[netcat]
  realize Package[cron]
}
