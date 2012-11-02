$:.push File.expand_path(File.dirname(__FILE__) + '/ftt')
$:.push File.expand_path(File.dirname(__FILE__) + '/ftt/gui')
$:.push File.expand_path(File.dirname(__FILE__) + '/ftt/models')

#gems
require 'digest'
require 'logger'
require 'csv'
require "google_drive"
require 'date'
require 'fox16'
#
require 'config'
require 'gd'
#gui
require 'main'
require 'messages'
require 'settings'
#models
require 'maconomy'
