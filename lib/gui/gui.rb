require 'fox16'
include Fox

# Main Gui bootstrap
# Author: Andrei
# TODO : refactoring !

class Gui < FXMainWindow
  #class constants
  APP_DEFAULT_WIDTH = 300
  APP_DEFAULT_HEIGHT = 100
  HORIZONTAL_FRAME_DEFAULT_WIDTH = 300
  HORIZAONTAL_FRAME_DEFAULT_HEIGHT = 45

  protected

  #create FXFont object
  def _create_font(face = 'Helvetica',size = 200,weight = FONTWEIGHT_NORMAL)
    f = FXFontDesc.new()
    f.encoding = FONTENCODING_DEFAULT
    f.face = face
    f.flags = 0
    f.setwidth = FONTSETWIDTH_WIDE
    f.size = size
    f.slant = FONTSLANT_REGULAR
    f.weight = weight

    return (f)
  end

  #create FX widgets
  def _prepare_layout
    @hFrame1 = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => HORIZONTAL_FRAME_DEFAULT_WIDTH, :height => HORIZAONTAL_FRAME_DEFAULT_HEIGHT)
      @hFrame1Label = FXLabel.new(@hFrame1,"Task:")
        @hFrame1Label.font = FXFont.new(getApp(),_create_font())
      @hFrame1TextField = FXTextField.new(@hFrame1,30, :opts => LAYOUT_FILL)
    @vFrame1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
      @hFrame2 = FXHorizontalFrame.new(@vFrame1)
        @generateButton = FXButton.new(@hFrame2, "Start timer")
        @settingButton = FXButton.new(@hFrame2, "Settings")
        @counterLabel = FXLabel.new(@hFrame2,Time.at("#{@i}".to_i).gmtime.strftime('%R:%S'))
        @counterLabel.hide
  end

  #create events
  def _prepare_events
    @generateButton.connect(SEL_COMMAND) do |sender, selector, data|
      @counterLabel.show
      @counterLabel.recalc
      getApp().addTimeout(1000, method(:onTimeout))
    end
  end

  public
  # construct the FX app
  def initialize(app)
    super(app, "Ftt YO", :width => APP_DEFAULT_WIDTH, :height => APP_DEFAULT_HEIGHT)
    @i = 1
    _prepare_layout()
    _prepare_events()
  end

  def onTimeout(sender, sel, ptr)
    puts @i += 1
    @counterLabel.text = Time.at("#{@i}".to_i).gmtime.strftime('%R:%S')
    getApp().addTimeout(1000, method(:onTimeout))
  end

  #create (display) the FX app
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end