require 'fox16'
include Fox

class FirstTime < FXMessageBox
  def initialize(owner)
    super(owner, "Yo dude","Seems like you're a first timer . Do you want to configure the app ?",nil,MBOX_YES_NO)
  end
end