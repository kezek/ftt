require 'fox16'
include Fox

class Settings < FXDialogBox

  attr_reader :GUsername,:GPassword,:hFrame3

  def initialize(owner)
    # Invoke base class initialize function first
    super(owner, "Settings", DECOR_TITLE|DECOR_BORDER)
    hFrame1 = FXHorizontalFrame.new(self)
      hFrame1Label1 = FXLabel.new(hFrame1,"Google account username:")
      @GUsername = FXTextField.new(hFrame1,30, :opts => LAYOUT_FILL)
    hFrame2 = FXHorizontalFrame.new(self)
      hFrame2Label = FXLabel.new(hFrame2,"Google account password:")
      @GPassword = FXTextField.new(hFrame2,30, :opts => LAYOUT_FILL|TEXTFIELD_PASSWD)
    FXHorizontalSeparator.new(self, SEPARATOR_GROOVE)
    @hFrame3 = FXHorizontalFrame.new(self)
      FXButton.new(hFrame3, "Accept", nil, self, ID_ACCEPT,
      FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
  end
end
