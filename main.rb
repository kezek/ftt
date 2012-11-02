$:.push File.expand_path(File.dirname(__FILE__) + '/lib')
require 'db'
require 'ftt'

if __FILE__ == $0
  FXApp.new do |app|
    Gui.new(app)
    app.create
    app.run
  end
end
