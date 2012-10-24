require 'fox16'
include Fox

class Settings < FXDialogBox

  attr_reader :GUsername, :GPassword, :GSpreadsheetKey

  def initialize(owner)
    # Invoke base class initialize function first
    super(owner, "Settings", DECOR_TITLE|DECOR_BORDER)
      hFrame1 = FXHorizontalFrame.new(self)
      vFrame1 = FXVerticalFrame.new(hFrame1)
        hFrame1Label1 = FXLabel.new(vFrame1, "Google username:",:padTop => 4)
        hFrame2Label = FXLabel.new(vFrame1, "Google password:", :padTop => 4)
        hFrame3Label = FXLabel.new(vFrame1, "Spreadsheet Key:", :padTop => 4)
      vFrame2 = FXVerticalFrame.new(hFrame1)
        @GUsername = FXTextField.new(vFrame2, 45,
          :opts => LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
        @GPassword = FXTextField.new(vFrame2, 45,
          :opts => TEXTFIELD_PASSWD|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
        @GSpreadsheetKey = FXTextField.new(vFrame2, 45,
          :opts => LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
      hFrame2 = FXHorizontalFrame.new(self)
        acceptButton = FXButton.new(hFrame2, "Accept", nil, self, ID_ACCEPT,
          FRAME_RAISED|FRAME_THICK|LAYOUT_CENTER_Y)
        acceptButton.setDefault
        acceptButton.setFocus
  end
end
