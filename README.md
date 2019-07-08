# db-connect

## What does this do?

Small convenience library for Ruby to give a hash of database connection
parameters stored in a YAML file. By default, the file it will look for is at
`~/.secure/db_connections.yml`, but you can make it look elsewhere by passing
in a different YAML file location to the constructor.

## How to use it

Given a YAML file with your database connection entries that look like this:

    :my_cool_db:
        :adapter: mysql2
        :host: db.example.com
        :user: cooluser
        :password: cool_secret_password
        :database: cooldb

You can connect to it with the [Sequel gem](https://github.com/jeremyevans/sequel) like this:

    require 'db-connect'
    DB = DBConnect[:my_cool_db] # Short for DBConnect.new(DBConnect::DEFAULT_YAML_FILE).as_hash(:my_cool_db)
    DB[:my_table].limit(10).all # => [{:col1=>42, :col2=>43}, ...]
