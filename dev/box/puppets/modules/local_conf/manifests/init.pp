# Class: local_conf
# ===========================
#
# Right now this module works with predefined paths, like 'application'
#
# Examples
# --------
#
# hiera.yaml
# local_conf:
#   application:
#     -
#       file: 'config.json'
#       provider: json
#       content:
#         local:
#           foo: bar
#     -
#       file: 'aws_s3.yml'
#       provider: yaml
#       content:
#         secret: 'omgomgomgomgomgomgomg'
#         bucket: 'foo'
#
# Authors
# -------
#
# Maximilian Ruediger <maximilian.ruediger@berlinonline.de>
#
# Copyright
# ---------
#
# Copyright 2016 BerlinOnline.
#
class local_conf
{
  require ::berlinonline::roles::application
  $local_conf = hiera('local_conf', [])
  unless empty($local_conf) {
    $application_conf = $local_conf['application']
    $application_dir  = "/usr/local/${::berlinonline::application_name}"
    unless empty($application_conf) {
      $application_conf.each | $file | {
        hash_file { "${application_dir}/${file['file']}" :
          value => $file['content'],
          provider => $file['provider']
        }
      }
    }
  }
}
