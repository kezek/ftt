require_relative './db'
require 'singleton'
require 'digest'
require 'logger'

# configuration
module Ftt
  class Config
    include Db
    include Singleton

    CONFIG_TABLE = 'config'

    attr_reader :logger

    public
    def initialize
      puts 'CONFIGURATION'
      logFilePath = File.expand_path("../../../data/log.txt", __FILE__)
      file = File.open(logFilePath, File::WRONLY | File::APPEND | File::CREAT)
      @logger = Logger.new(file)
      super
    end

    def configured?
      result = Db.instance.get_first_value("SELECT count (*) FROM sqlite_master WHERE type='table' AND name= ?;",CONFIG_TABLE)
      result != 0 ? true : false
    end

    def saveConfiguration(data)
      if !data.empty?
        begin
          Db.instance.execute("CREATE table if not exists #{CONFIG_TABLE} (key TEXT UNIQUE, value TEXT)")

          Db.instance.execute("INSERT OR REPLACE INTO config values ( ?, ? )",
                              'gusername', data["gusername"].encode('UTF-8'))

          Db.instance.execute("INSERT OR REPLACE INTO config values ( ?, ? )",
                              'gpassword', data["gpassword"].encode('UTF-8'))

          Db.instance.execute("INSERT OR REPLACE INTO config values ( ?, ? )",
                              'gspreadsheetkey', data["gspreadsheetkey"].encode('UTF-8'))
        rescue => e
          @logger.error(e.message)
        end
      end
    end

    def getGUsername
      begin
        Db.instance.get_first_value("SELECT value FROM config WHERE key = 'gusername'")
      rescue => e
        @logger.error(e.message)
      end
    end

    def getGPassword
      begin
        Db.instance.get_first_value("SELECT value FROM config WHERE key = 'gpassword'")
      rescue => e
        @logger.error(e.message)
      end
    end

    def getGSpreadsheetKey
      begin
        Db.instance.get_first_value("SELECT value FROM config WHERE key = 'gspreadsheetkey'")
      rescue => e
        @logger.error(e.message)
      end
    end
  end
end
