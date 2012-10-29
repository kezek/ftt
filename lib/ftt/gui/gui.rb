require 'fox16'
require_relative '../config'
require_relative './settings'
require_relative './messages'
require_relative '../gd'
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
      @taskField = FXTextField.new(@hFrame1,30, :opts => LAYOUT_FILL)
    @vFrame1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
      @hFrame2 = FXHorizontalFrame.new(@vFrame1)
        @counterButton = FXButton.new(@hFrame2, "Start timer")
        @resetButton = FXButton.new(@hFrame2,"Reset timer")
        @settingsButton = FXButton.new(@hFrame2, "Settings")
        # TODO finish implementantion
        @saveButton = FXButton.new(@hFrame2,"Save")
        # 
        @counterLabel = FXLabel.new(@hFrame2,formatTime(@counterValue))
        @counterLabel.hide
  end

  #create events
  def _prepareEvents
    #counter related logic
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
    @resetButton.connect(SEL_COMMAND) do
      @counterValue = 0
      @counterLabel.text = formatTime(0)
      @counterLabel.recalc
    end
    

    #setting dialog
    if Ftt::Config.instance.configured? == false
      response = @firstTimeMessage.execute
      # if clicked on Yes on @firstTimeMessage
      if response == 1
        _displaySettingDialog
      end
    end

    if validateSettings == false
      _displaySettingDialog
    end

    # display setting dialog when clicking on the Setting Button
    @settingsButton.connect(SEL_COMMAND) do
      _displaySettingDialog
    end
    #saveButton
    @saveButton.connect(SEL_COMMAND) do
      Ftt::GD.save(@taskField.text)
    end
  end

  def _displaySettingDialog
    response = @settingsDialog.execute
    data = Hash.new
    #TODO : use symbols instead of strings
    data['gusername'] = @settingsDialog.GUsername.text
    data['gpassword'] = @settingsDialog.GPassword.text
    data['gspreadsheetkey'] = @settingsDialog.GSpreadsheetKey.text
    data['maconomy'] = @settingsDialog.maconomyData.to_s
    data['username'] = @settingsDialog.Username.text
    
    Ftt::Config.instance.saveConfiguration(data)
    # while current setings are invalid keep displaying
    # the Settings Dialog
    if validateSettings == false
      _displaySettingDialog
    end
  end

  #prepare messages
  def _prepareDialogs
    @firstTimeMessage = FirstTime.new(self)
    @GDConnectError = GoogleDriveConnectError.new(self)
    @GDSpreadsheetError = GoogleDriveInvalidSpreadsheet.new(self)
    #create the setting dialog and hide it initially
    @settingsDialog = Settings.new(self)
  end

  def _onTimerButtonClick(sender, sel, ptr)
    @counterValue += 1
    @counterLabel.text = formatTime(@counterValue)
    @counterButtonTimeout = @app.addTimeout(1000, method(:_onTimerButtonClick))
  end

  public

  # validates current settings and throws message boxes
  # in case of invalid settings
  # @return bool
  def validateSettings
    begin
      Ftt::GD.login
      begin
        Ftt::GD.getLatestWorksheet
      rescue
        @GDSpreadsheetError.execute
        return false
      end
    rescue
      @GDConnectError.execute
      return false
    end

    return true
  end

  # construct the FX app
  def initialize(app)
    super(app, "Ftt YO", :width => APP_DEFAULT_WIDTH, :height => APP_DEFAULT_HEIGHT)
    @counterValue = 1
    @app = getApp
    _prepareLayout

  end

  def formatTime(seconds)
    Time.at("#{seconds}".to_i).gmtime.strftime('%R:%S')
  end

  #create (display) the FX app
  def create
    super
    _prepareDialogs
    _prepareEvents
    show(PLACEMENT_SCREEN)
  end
end
