require "yaml"
require "active_support/core_ext/hash/keys" # deep_symbolize_keys
require "sequel"

# Sequel extensions that monkeypatch core classes by adding convenience methods.
Sequel.extension :core_extensions
Sequel.extension :symbol_aref

class DBConnect
  DEFAULT_YAML_FILE = "~/.secure/db_connections.yml"

  attr_reader :yaml_file

  def initialize(yaml_file = DEFAULT_YAML_FILE)
    @yaml_file = File.expand_path yaml_file
  end

  def connections
    YAML.load_file(yaml_file).deep_symbolize_keys
  end

  def as_hash(connection_name)
    connections[connection_name]
  end

  def sequel(connection_name)
    db = Sequel.connect(as_hash(connection_name))

    # HACK: If this MySQL, force default character set variables to latin1 to
    # prevent "Illegal mix of collation errors". Surely there is a better way to
    # handle this.
    if as_hash(connection_name)[:adapter] =~ /^mysql/i
      db.run "set character_set_client = latin1"
      db.run "set character_set_connection = latin1"
      db.run "set character_set_database = latin1"
      db.run "set character_set_results = latin1"
    end

    db
  end

  # class method shortcut for DBConnect.new.sequel(connection_name)
  def self.[](connection_name, yaml_file = DEFAULT_YAML_FILE)
    DBConnect.new(yaml_file).sequel(connection_name)
  end
end
