require 'fox16'
include Fox

class Interface < FXMainWindow
  def initialize(app)
    super(app, "Ftt YO", :width => 400, :height => 200)
    h_frame_1 = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => 250, :height => 50)
    h_frame_1_label = FXLabel.new(h_frame_1,"Task:")
    h_frame_1_text_field = FXTextField.new(h_frame_1,30, :opts => LAYOUT_FILL)
    vFrame1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
    hFrame3 = FXHorizontalFrame.new(vFrame1)
    generateButton = FXButton.new(hFrame3, "Generate")
    copyButton = FXButton.new(hFrame3, "Copy to clipboard")
    
    #    v_frame_1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
    #    v_frame_1_textarea = FXText.new(v_frame_1, :opts => LAYOUT_FILL)
    #    hFrame1 = FXHorizontalFrame.new(self)
    #    chrLabel = FXLabel.new(hFrame1, "Number of characters in password:")
    #    chrTextField = FXTextField.new(hFrame1, 4)
    #    hFrame2 = FXHorizontalFrame.new(self)
    #    specialChrsCheck = FXCheckButton.new(hFrame2, "Include special characters in password")
    #    vFrame1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
    #    textArea = FXText.new(vFrame1, :opts => LAYOUT_FILL | TEXT_READONLY | TEXT_WORDWRAP)
    #    hFrame3 = FXHorizontalFrame.new(vFrame1)
    #    generateButton = FXButton.new(hFrame3, "Generate")
    #    copyButton = FXButton.new(hFrame3, "Copy to clipboard")
  end
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end