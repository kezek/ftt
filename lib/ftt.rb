$:.push File.expand_path(File.dirname(__FILE__) + '/ftt')
$:.push File.expand_path(File.dirname(__FILE__) + '/ftt/gui')
$:.push File.expand_path(File.dirname(__FILE__) + '/ftt/models')

#gems
require 'digest'
require 'logger'
require 'csv'
#
require 'db'
require 'config'
require 'gd'
#gui
require 'gui'
require 'messages'
require 'settings'
#models
require 'maconomy'
