require 'sqlite3'
# Module for conneting with the DB
#singleton pattern
module Db
  DB_PATH = File.expand_path(File.dirname(__FILE__))


  public
  def initialize
    Db.connect
  end

  def self.instance
    return
    @@db
  end

  protected
  def self.connect
    puts 'CONNECTED'
    puts DB_PATH
    @@db = SQLite3::Database.new(DB_PATH)
  end
end
