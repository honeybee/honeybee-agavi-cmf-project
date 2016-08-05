## 2016-06-29 - Release 1.7.2

- Fix validation of the size parameter (fix #70, fix #58)

## 2016-03-30 - Release 1.7.1

- Fix false parsing of IPAddress field (issue #61)
- Fix openssl_version fact on RedHat-based OSes (issue #66, fixes #62 and #65)

## 2016-03-18 - Release 1.7.0

- Add openssl_version fact (issue #60, fix #57)
- Various fixes to tests

## 2016-02-22 - Release 1.6.1

- Fix failure to load inifile (issue #56)

## 2016-02-18 - Release 1.6.0

- Change certificate existence logic (issue #51)
- Add dhparam type and provider (issue #53)
- Fix unit tests for Puppet 4

## 2015-11-17 - Release 1.5.1

Use ensure_package for ca-certificate

## 2015-09-23 - Release 1.5.0

Customizable cnf/crt/csr/key paths

## 2015-09-15 - Release 1.4.0

Add a req_ext parameter to x509_cert type
Allow to manage whether adding v3 SAN from config

## 2015-08-21 - Release 1.3.10

Use docker for acceptance tests

## 2015-06-26 - Release 1.3.9

Fix strict_variables activation with rspec-puppet 2.2

## 2015-05-28 - Release 1.3.8

Add beaker_spec_helper to Gemfile

## 2015-05-26 - Release 1.3.7

Use random application order in nodeset

## 2015-05-26 - Release 1.3.6

add utopic & vivid nodesets

## 2015-05-25 - Release 1.3.5

Don't allow failure on Puppet 4

## 2015-05-13 - Release 1.3.4

Add puppet-lint-file_source_rights-check gem

## 2015-05-12 - Release 1.3.3

Don't pin beaker

## 2015-04-27 - Release 1.3.2

Add nodeset ubuntu-12.04-x86_64-openstack

## 2015-04-17 - Release 1.3.1

- Add beaker nodesets

## 2015-04-03 - Release 1.3.0

- Use sha256 instead of sha1 by default
- Confine rspec pinning to ruby 1.8

## 2015-03-24 - Release 1.2.8

- Various spec improvements

## 2015-03-10 - Release 1.2.7

- Stop managing ca-certificates file
- Various spec improvements

## 2015-02-18 - Release 1.2.6

- Various spec improvements
- Linting

## 2015-01-19 - Release 1.2.5

- Add puppet-lint plugins

## 2015-01-07 - Release 1.2.4

- Fix unquoted strings in cases

## 2015-01-05 - Release 1.2.3

- Fix .travis.yml

## 2014-12-18 - Release 1.2.2

- Fix LICENSE file to match metadata.json
- Remove puppet_version from metadata.json

## 2014-12-18 - Release 1.2.1

- Various improvements in unit tests

## 2014-12-09 - Release 1.2.0

- Fix metadata.json warnings
- Add future parser tests
- Fix future parser errors

## 2014-11-25 - Release 1.1.0

- Corrected and added new features for openssl::export::pkcs12

## 2014-11-17 - Release 1.0.1

- Lint metadata.json

## 2014-10-20 - Release 1.0.0

- Setup automatic Forge releases

## 2014-07-02 - Release 0.3.0

- Add more tests
