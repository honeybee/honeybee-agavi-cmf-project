# Class: berlinonline::nginx::application
#
#
class berlinonline::nginx::application{
  require ::nginx
  require ::php

  #we do have the option to deploy with ssl or not
  if $::berlinonline::application_https {
    include ::berlinonline::nginx::https
  }
  else {
    include ::berlinonline::nginx::http
  }
}
