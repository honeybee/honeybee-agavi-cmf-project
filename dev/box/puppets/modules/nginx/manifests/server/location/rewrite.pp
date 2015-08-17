location / {

# change the ? to & to prevent loosing GET parameters in the final rewrite.
rewrite ^(.*)\?(.*)$ $1&$2;

# Everything is directed to index.php, unless the file actually exists within the root.
if (!-f $request_filename) {
rewrite ^/(.*)$ /index.php?/$1  last;
break;
}

}
