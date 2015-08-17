node 'default'{
  require ::basics::packages
  stage { 'last': }
  Stage['main'] -> Stage['last']
  hiera_include('roles')

  if versioncmp($::puppetversion,'3.6.1') >= 0 {

    $allow_virtual_packages = hiera('allow_virtual_packages',false)

    Package {
      allow_virtual => $allow_virtual_packages,
    }
  }
}
