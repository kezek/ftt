#$:.push File.expand_path(File.dirname(__FILE__) + '/ftt')
#$:.push File.expand_path(File.dirname(__FILE__) + '/ftt/gui')
#$:.push File.expand_path(File.dirname(__FILE__) + '/ftt/models')

#gems
require 'digest'
require 'logger'
require 'csv'
require "google_drive"
require 'date'
require 'fox16'
require 'fileutils'
#
require_relative './ftt/config'
require_relative './ftt/gd'
#gui
require_relative './ftt/gui/main'
require_relative './ftt/gui/messages'
require_relative './ftt/gui/settings'
#models
require_relative './ftt/models/maconomy'
