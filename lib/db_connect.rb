require "yaml"
require "sequel"

class DBConnect
  DEFAULT_YAML_FILE = "~/.secure/db_connections.yml"

  attr_reader :yaml_file

  def initialize(yaml_file = DEFAULT_YAML_FILE)
    @yaml_file = File.expand_path yaml_file
  end

  def connections
    YAML.load_file(yaml_file)
  end

  def as_hash(connection_name)
    connections[connection_name]
  end

  def sequel(connection_name)
    Sequel.connect(as_hash(connection_name))
  end

  # class method shortcut for DBConnect.new.sequel(connection_name)
  def self.[](connection_name, yaml_file = DEFAULT_YAML_FILE)
    DBConnect.new(yaml_file).sequel(connection_name)
  end
end
