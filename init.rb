$:.push File.expand_path(File.dirname(__FILE__) + '/lib')
require 'db'
require 'float'
require 'ftt'

if __FILE__ == $0
  FXApp.new do |app|
    #TODO : boostrap should be another class , not Main
    Ftt::Main.new(app)
    app.create
    app.run
  end
end
