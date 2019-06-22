# db-connect
Small convenience library for Ruby to give a hash of database connection 
parameters stored in a YAML file. By default, the file is at `~/.secure/db_connections.yml`.

Also, support for passing the config hashes directly `Sequel.connect` is provided via
a convient call:

    DB = DBConnect[:my_cool_db]
