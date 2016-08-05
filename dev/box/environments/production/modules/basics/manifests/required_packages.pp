# Class: basics::required_packages
#
#
class basics::required_packages {
  ensure_packages($::berlinonline::required_packages)
}