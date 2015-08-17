class couchdb(
  $setup            = 'stable',
  $port             = 5984,
  $bind_address     = ''
)
{
  require ::couchdb::server
}
