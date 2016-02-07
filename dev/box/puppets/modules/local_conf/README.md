# local_conf

#### Table of Contents

Reads all definied local configuration files from hiera config key ```local_conf.application``` and puts them into an application specific local config folder (usually ```/usr/local/[application_name]```.

## Usage

Use code like the following in your hiera yaml definition :

```yaml
local_conf:
     application:
       -
         file: aws_s3.yml
         provider: yaml
         content:
           secret: omgomgomgomgomgomgomg
           bucket: foo
       -
        file: middleware.json
        provider: json
        content:
          host: somehost
          protocol: 'https'
          nested:
            foo: bar
            baz: blah
```
