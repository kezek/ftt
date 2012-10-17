require_relative './db'
# configuration
# TODO : create relative path for DB
module Ftt
  class Config
    include Db

    CONFIG_TABLE = 'config'

    public
    def initialize
      super
    end

    def configured?
      result = Db.instance.get_first_value("SELECT count (*) FROM sqlite_master WHERE type='table' AND name= ?;",CONFIG_TABLE)
      if result != 0
        true
      else
        false
      end
    end
  end
end

puts Ftt::Config.new.configured?

