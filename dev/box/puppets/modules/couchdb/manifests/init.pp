class couchdb(
  $setup            = 'stable',
  $port             = 5984,
  $bind_address     = '',
  $version          = 'latest'
)
{
  require ::couchdb::server
}
