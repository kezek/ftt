require_relative './db'
require 'singleton'

# configuration
# TODO : create relative path for DB
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
      result = Db.instance.get_first_value("SELECT count (*) FROM sqlite_master WHERE type='table' AND name= ?;",CONFIG_TABLE)
      result != 0 ? true : false
    end
  end
end

puts Ftt::Config.instance.configured?

