require 'sqlite3'

# Module for conneting with the DB
#singleton pattern
module Db
  DB_PATH = File.expand_path("../../../data/ftt.db", __FILE__)

  public
  def initialize
    Db.connect
  end

  def self.instance
    @@db
  end

  protected
  def self.connect
    puts 'CONNECTED'
    @@db = SQLite3::Database.new(DB_PATH)
  end
end
