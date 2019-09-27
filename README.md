# db-connect

## What is this?

I find myself needing to connect to various databases constantly, copying and
pasting usernames, passwords, host into files everywhere. This is a poor
practice, but I see other people doing it the time too. So I decided to put
these in one secure place on my development machine: a YAML file at
`~/.secure/db_connections.yml` (protected by `chmod 700 ~/.secure`).

In Ruby I use the[Sequel](https://github.com/jeremyevans/sequel) gem to interact
with databases, so I wrote this small convenience library to help in passing a
hashmap of database connection parameters coming from the YAML file and get back
a database connection object. By default, the YAML file it will look for is at
`~/.secure/db_connections.yml`, but you can make it look elsewhere by passing in
a different YAML file location to the constructor.

## How to use it

Given a YAML file on your system with your database connection entries that look
like this:

    :my_cool_db:
        :adapter: mysql2
        :host: db.example.com
        :user: cooluser
        :password: cool_secret_password
        :database: cooldb

You can connect to it like this:

    require 'db-connect'
    DB = DBConnect[:my_cool_db] # Short for DBConnect.new(DBConnect::DEFAULT_YAML_FILE).as_hash(:my_cool_db)
    DB[:my_table].limit(10).all # => [{:col1=>42, :col2=>43}, ...]

See Sequel's Github page for more info on its API.

### Example of MySQL YAML entry

    :foo_mysql_db:
        :adapter: mysql2
        :host: foo-db-host.com
        :user: bob
        :password: secretpassword1
        :database: foo_db
        :compress: true
        :servers:
          :read_only:
            :host: foo-db-host-ro.com

### Example of Redshift YAML entry

    :foo_redshift_db:
      :adapter: redshift
      :host: foo-analytics-db.redshift.amazonaws.com
      :port: 8192
      :database: foo_analytics_db
      :user: bob
      :password: 'dudewheresmycar'
      :force_standard_strings: false
      :client_min_messages: false
