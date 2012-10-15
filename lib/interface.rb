require 'fox16'
include Fox

# Interface class
# Author: Andrei

class Interface < FXMainWindow
  
  protected 
  #create FXFont object
  
  def _create_font(weight = FONTWEIGHT_NORMAL)
    f = FXFontDesc.new()
    f.encoding = FONTENCODING_DEFAULT
    f.face = "Helvetica"
    f.flags = 0
    f.setwidth = FONTSETWIDTH_WIDE
    f.size = 200
    f.slant = FONTSLANT_REGULAR
    f.weight = weight

    return (f)
  end
  
  public
  # construct the FX app
  
  def initialize(app)
    super(app, "Ftt YO", :width => 300, :height => 100)
    h_frame_1 = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => 250, :height => 50)
    h_frame_1_label = FXLabel.new(h_frame_1,"Task:")
    h_frame_1_label.font = FXFont.new(getApp(),_create_font())
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
  
  #create (display) the FX app
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end