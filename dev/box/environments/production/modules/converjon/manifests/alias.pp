#creates a converjon alias
define converjon::alias (String $base_file_path, Array $headers = [], Array $fallback_base_file_paths = []) {
  file { "${converjon::alias_basepath}/${name}.yml":
    ensure  => file,
    content => template('converjon/alias.erb')
  }
}