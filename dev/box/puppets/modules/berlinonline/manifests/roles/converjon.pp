# Class: berlinonline::roles::converjon
#
#
class berlinonline::roles::converjon {
	class { '::converjon' :
		require => Class['::berlinonline']
	}
}