# Getting Postgresql running on OSX Mountain Lion

There are plenty of posts around the internet that detail how to install Postgresql, however I recently had a hell of a time getting it running on a fresh Mountain Lion install.

Maybe this just affected me and I had something conflicting somewhere, but I've detailed all the steps I took below incase someone else finds themselves in a similar situation.

## Install Postgres from Homebrew

I love homebrew and use it for all my package management on my Mac, check out their site for more information.

$> brew update
$> brew install postgres

## $PATH Setup

This one caught me out. Ensure that the /usr/local/bin path is before /usr/bin in your $PATH environment variable

You can do this by adding
```
$> export PATH=/usr/local/bin:$PATH
```
to your .bash_profile or .zshrc file

## Initialise postgres

Run the following command to setup postgres for the first time
```
$> initdb /usr/local/var/postgres -E utf8
```
If this fails, it's possibly to do with shared memory issues so look for this (or similar) in the output from the initdb call
```
$> FATAL:  could not create shared memory segment: Cannot allocate memory
```
If you get this issue you can either reduce the shared memory requirements of postgres, or increase the system settings. I went with the latter
```
$> sudo sysctl -w kern.sysv.shmall=65536
$> sudo sysctl -w kern.sysv.shmmax=16777216
```
To ensure these settings survive reboots, add them to the /etc/sysctl.conf which may need to be created if it's not already there.
```
$> sudo vim /etc/sysctl.conf

$> kern.sysv.shmall=65536
$> kern.sysv.shmmax=16777216
```
Finally rerun
```
$> initdb /usr/local/var/postgres -E utf8
```
This should work with something similar to the following output

The files belonging to this database system will be owned by user "USER".
This user must also own the server process.

The database cluster will be initialized with locale "en_GB.UTF-8".
The default text search configuration will be set to "english".
```
$> creating directory /usr/local/var/postgres ... ok
$> creating subdirectories ... ok
$> selecting default max_connections ... 100
$> selecting default shared_buffers ... 8000kB
$> creating configuration files ... ok
$> creating template1 database in /usr/local/var/postgres/base/1 ... ok
$> initializing pg_authid ... ok
$> initializing dependencies ... ok
$> creating system views ... ok
$> loading system objects' descriptions ... ok
$> creating collations ... ok
$> creating conversions ... ok
$> creating dictionaries ... ok
$> setting privileges on built-in objects ... ok
$> creating information schema ... ok
$> loading PL/pgSQL server-side language ... ok
$> vacuuming database template1 ... ok
$> copying template1 to template0 ... ok
$> copying template1 to postgres ... ok
```
## Starting Postgres

Next up try starting the postgres server
```
$> pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
```
## Can Rails/Rake connect?

Now go to your Rails app and run the rake db:create command. If all is working then it should run and you can start running migrations and off you go.
However... I ran into the next error on this post.

## No Socket

When running the rake db:create command I got the follow error
```
$> could not connect to server: No such file or directory
$>     Is the server running locally and accepting
$>     connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?
```
For some reason, after everything else, rake & rails just couldn't connect to postgres. Turns out that the socket file wasn't created.

To fix this I ended up having to create the expected socket paths maually.
```
$> sudo mkdir /var/pgsql_socket/
$> ln -s /private/tmp/.s.PGSQL.5432 /var/pgsql_socket/
```
With this final step I was able to connect my app to the postgres server running locally and start work.

If there are better solutions to these issues I'd love to hear about it, you can drop me a line through the contact form for now as I don't have comments on this blog, and I will update the post with anything I receive

## Final Note

As part of this install I also install the lunchy gem to handle starting and stopping postgres.
```
$> gem install lunchy
```
Then add the postgres from homebrew to lunchy
```
$> mkdir -p ~/Library/LaunchAgents
$> cp /usr/local/Cellar/postgresql/9.2.3/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents
$> launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```
Just remember here to make sure you get your version of postgres, don't just copy and paste the above commands.

Once this is done, postgres can be started and stopped with
```
$> lunchy start postgres
$> lunchy stop postgres
```

## Source
http://www.fullybaked.co.uk/articles/getting-postgresql-running-on-osx-mountain-lion