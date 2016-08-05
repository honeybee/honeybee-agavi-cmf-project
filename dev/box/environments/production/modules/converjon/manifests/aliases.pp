# Class: converjon::aliases
#
#
class converjon::aliases(
)
{
  #deploys aliases for converjon work
  if count($converjon::aliases) == 0 {
    debug ('Not deploying any aliases for converjon')
  }
  else {
    file { '/etc/converjon/aliases':
      ensure  => directory,
      purge   => true,
      recurse => true
    }
    each($converjon::aliases) |$alias| {
      ::converjon::alias { $alias[name] :
        base_file_path           => $alias[base_file_path],
        headers                  => $alias[headers],
        notify                   => Service[converjon],
        fallback_base_file_paths => $alias[fallback_base_file_paths],
      }
    }
  }

}