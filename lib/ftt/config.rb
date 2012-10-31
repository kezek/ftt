require_relative './db'
require_relative './models/maconomy'
require 'singleton'
require 'digest'
require 'logger'
require 'csv'

# configuration
module Ftt
  class Config
    include Db
    include Singleton

    CONFIG_TABLE = 'config'    

    attr_reader :logger

    public
    def initialize
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

          Db.instance.execute("INSERT OR REPLACE INTO #{CONFIG_TABLE} values ( ?, ? )",
                              'gusername', data["gusername"].encode('UTF-8'))

          Db.instance.execute("INSERT OR REPLACE INTO #{CONFIG_TABLE} values ( ?, ? )",
                              'gpassword', data["gpassword"].encode('UTF-8'))

          Db.instance.execute("INSERT OR REPLACE INTO #{CONFIG_TABLE} values ( ?, ? )",
                              'gspreadsheetkey', data["gspreadsheetkey"].encode('UTF-8'))
                                
          Db.instance.execute("INSERT OR REPLACE INTO #{CONFIG_TABLE} values ( ?, ? )",
                                        'username', data["username"].encode('UTF-8'))
                                
          #avoid process in case no maconomy code has been changed
          if getMaconomyCodesCombined === nil || data["maconomy"] != getMaconomyCodesCombined   
            Maconomy.new.save(data["maconomy"])
            setMaconomyCodesCombined(data['maconomy'])
          end
        rescue => e
          @logger.error(e.message)
        end
      else
        raise 'No input data received'
      end
    end

    def getGUsername
      begin
        Db.instance.get_first_value("SELECT value FROM #{CONFIG_TABLE} WHERE key = 'gusername'")
      rescue => e
        @logger.error(e.message)
      end
    end

    def getGPassword
      begin
        Db.instance.get_first_value("SELECT value FROM #{CONFIG_TABLE} WHERE key = 'gpassword'")
      rescue => e
        @logger.error(e.message)
      end
    end

    def getGSpreadsheetKey
      begin
        Db.instance.get_first_value("SELECT value FROM #{CONFIG_TABLE} WHERE key = 'gspreadsheetkey'")
      rescue => e
        @logger.error(e.message)
      end
    end
    
    def getMaconomyCodesCombined
      begin
        Db.instance.get_first_value("SELECT value FROM #{CONFIG_TABLE} WHERE key = 'maconomy_codes_combined'")
      rescue => e
        @logger.error(e.message)
      end
    end
    
    def setMaconomyCodesCombined(data)
      begin
        Db.instance.execute("INSERT OR REPLACE INTO #{CONFIG_TABLE} values ( ?, ? )",
                            'maconomy_codes_combined', data.encode('UTF-8'))
      rescue => e
        @logger.error(e.message)
      end
    end
    
    # Username is the value the will be used to populate the
    # 'User' column in the worksheet
    def getUsername
      begin
        Db.instance.get_first_value("SELECT value FROM #{CONFIG_TABLE} WHERE key = 'username'")
      rescue => e
        @logger.error(e.message)
      end
    end
  end
end
