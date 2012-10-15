require './lib/gui/gui.rb'

if __FILE__ == $0
  FXApp.new do |app|
    Gui.new(app)
    app.create
    app.run
  end
end