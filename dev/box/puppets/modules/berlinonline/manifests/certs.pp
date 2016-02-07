# Class: berlinonline::certs
#
#
class berlinonline::certs {
  #deploys ssl certs
  realize Basics::Multi_package[certs]
}