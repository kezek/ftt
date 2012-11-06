#$:.push File.expand_path(File.dirname(__FILE__) + '/lib')
#gems
require 'digest'
require 'logger'
require 'csv'
require "google_drive"
require 'date'
require 'fox16'
require 'fileutils'
require 'sqlite3'

require_relative './lib/db'
require_relative './lib/float'
require_relative './lib/ftt'

if __FILE__ == $0
  FXApp.new do |app|
    #TODO : boostrap should be another class , not Main
    Ftt::Main.new(app)
    app.create
    app.run
  end
end
