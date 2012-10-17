require 'fox16'
require_relative '../config'
include Fox

# Main Gui bootstrap
# Author: Andrei
# TODO : refactoring !

class Gui < FXMainWindow
  #include Db
  #class constants
  APP_DEFAULT_WIDTH = 300
  APP_DEFAULT_HEIGHT = 100
  HORIZONTAL_FRAME_DEFAULT_WIDTH = 300
  HORIZAONTAL_FRAME_DEFAULT_HEIGHT = 45

  protected

  #create FXFont object
  def _createFont(face = 'Helvetica',size = 200,weight = FONTWEIGHT_NORMAL)
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
  def _prepareLayout
    @hFrame1 = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => HORIZONTAL_FRAME_DEFAULT_WIDTH, :height => HORIZAONTAL_FRAME_DEFAULT_HEIGHT)
      @hFrame1Label = FXLabel.new(@hFrame1,"Task:")
        @hFrame1Label.font = FXFont.new(@app,_createFont())
      @hFrame1TextField = FXTextField.new(@hFrame1,30, :opts => LAYOUT_FILL)
    @vFrame1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
      @hFrame2 = FXHorizontalFrame.new(@vFrame1)
        @counterButton = FXButton.new(@hFrame2, "Start timer")
        @settingButton = FXButton.new(@hFrame2, "Settings")
        @counterLabel = FXLabel.new(@hFrame2,formatTime(@counterValue))
        @counterLabel.hide
  end

  #create events
  def _prepareEvents
    @counterButtonState = false

    @counterButton.connect(SEL_COMMAND) do
      #toggle button state (if enabled or not)
      @counterButtonState = !@counterButtonState
      @counterLabel.show
      @counterLabel.recalc
      #if the button state is active AKA we start the timer
      if @counterButtonState
        @counterButtonTimeout = @app.addTimeout(1000, method(:_onTimerButtonClick))
        @counterButton.text = 'Stop Timer'
      #else the button state is inactive AKA we stop the timer
      else
        if app.hasTimeout?(@counterButtonTimeout)
          @app.removeTimeout(@counterButtonTimeout)
          @counterButton.text = 'Start Timer'
        end
      end
    end
  end

  def _onTimerButtonClick(sender, sel, ptr)
    @counterValue += 1
    @counterLabel.text = formatTime(@counterValue)
    @counterButtonTimeout = @app.addTimeout(1000, method(:_onTimerButtonClick))
  end

  public
  # construct the FX app
  def initialize(app)
    super(app, "Ftt YO", :width => APP_DEFAULT_WIDTH, :height => APP_DEFAULT_HEIGHT)
    @counterValue = 1
    @app = getApp
    _prepareLayout
    _prepareEvents
  end

  def formatTime(seconds)
    Time.at("#{seconds}".to_i).gmtime.strftime('%R:%S')
  end

  #create (display) the FX app
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end
