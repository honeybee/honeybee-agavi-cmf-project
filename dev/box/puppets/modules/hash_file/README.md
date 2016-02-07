This is a puppet module to manage a file as a hash of either JSON or YAML data.

If you've ever used Puppet to try and write out some JSON or YAML to a file from a hash of data you've generated, then you've probably ended up with a template something like:

    ---
    <% @puppethash.keys.sort.each do |key| -%>
    <%= key %>: <%= @puppethash[key] %>
    <% end -%>

which is fine for a shallow object, but much much harder for deeper data.  You do this because Hashes are unordered, and the YAML or JSON you get out changes every single time if you just @thing.to_json, which results in file changes every Puppet run.  You probably didn't want this.

That situation no longer TM.  This type and pair of providers treats the contents of the file as the actual object represented by the JSON or YAML and compares the objects through the wonderment of the Puppet RAL.  It now no longer matters about Hash ordering, merely equivalence of the objects, which it turns out is quite easy.

EXAMPLE USAGE:

    fids$ cat /tmp/hiera/common.yaml
    ---
    foo:
      bar:
       baz: 'foo'
       moo: 1
       cow: '1'

    fids$ cat /tmp/foo.pp
    $foo = hiera(foo)
    hash_file { '/tmp/hash': value => $foo, provider => 'yaml' }

    fids$ puppet apply test.pp --modulepath=. --hiera_config=/etc/hiera.yaml
    Notice: /Stage[main]/Main/Hash_file[/tmp/hash]/value: value changed '' to '{"bar"=>{"baz"=>"foo", "moo"=>1, "cow"=>"1"}}'

    fids$ cat /tmp/hash
    ---
      bar:
        baz: foo
        moo: 1
        cow: "1"

License:

See LICENSE file

Changelog:

 - 15 April 2015 - initial release
 - 15 April 2015 - I probably lied about Windows
