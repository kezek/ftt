require_relative './db'
require 'singleton'
require 'digest'

# configuration
module Ftt
  class Config
    include Db
    include Singleton

    CONFIG_TABLE = 'config'

    public
    def initialize
      puts 'CONFIGURATION'
      super
    end

    def configured?
      return false
      result = Db.instance.get_first_value("SELECT count (*) FROM sqlite_master WHERE type='table' AND name= ?;",CONFIG_TABLE)
      result != 0 ? true : false
    end

    def saveConfiguration(data)
      if !data.empty?
        puts data["gusername"]
        Db.instance.execute("create table if not exists #{CONFIG_TABLE} (key TEXT UNIQUE, value TEXT)")
        Db.instance.execute("INSERT OR REPLACE INTO config values ( ?, ? )", 'gusername', data["gusername"].encode('UTF-8'))
        Db.instance.execute("INSERT OR REPLACE INTO config values ( ?, ? )",
                            'gpassword', Digest::MD5.hexdigest(data["gpassword"]).encode('UTF-8'))
      end
    end
  end
end
