# Class: converjon::install
#
#
class converjon::install {
  #installs given converjon version via npm

  package { 'ImageMagick':
    ensure => installed,
  }
  ->
  package { 'exiftool':
    ensure => installed,
  }
  ->
  file { '/etc/converjon':
    ensure => directory,
  }
  ->
  package { 'converjon':
    ensure   => $converjon::version,
    provider => 'npm',
    require  => Package[nodejs],
    notify   => Service[converjon]
  }

  #get the array of converjon_whitelists and add at least the given fqdn if empty
  if count($converjon::url_whitelist) == 0{
    $whitelist_url = [$::fqdn]
  }
  else {
    $whitelist_url = $converjon::url_whitelist
  }

  file { '/etc/sysconfig/converjon':
    ensure  => file,
    content => template('converjon/sysconfig.converjon.erb'),
    notify  => Service[converjon]
  }

  file { '/etc/converjon/config.yml':
    ensure  => file,
    require => File['/etc/converjon'],
    content => template('converjon/config.yml.erb'),
    notify  => Service[converjon]
  }

  #we cannot create and link a file, since its the same file resource with the same name
  exec { 'symlink_current_converjon_config':
    command => 'ln -s /etc/converjon/config.yml /etc/converjon/current.yml',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates => '/etc/converjon/current.yml',
    require => File['/etc/converjon/config.yml'],
  }

  file { '/etc/systemd/system/converjon.service':
    ensure  => file,
    content => template('converjon/converjon.service'),
    require => File['/etc/converjon/config.yml'],
    notify  => Exec['systemctl-daemon-reload']
  }

  service { 'converjon':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => File['/etc/systemd/system/converjon.service'],
    subscribe  => File['/etc/converjon/config.yml']
  }
}
