require 'fox16'
require_relative '../config'
require_relative './settings'
require_relative './messages'
require_relative '../gd'
include Fox

# Main Gui bootstrap
# Author: Andrei
# TODO : refactoring !

# adding round_down method to Float class
class Float
  def round_down n=0
  s = self.to_s
  l = s.index('.') + 1 + n
  s.length <= l ? self : s[0,l].to_f
  end
end

class Gui < FXMainWindow
  
  #class constants
  APP_DEFAULT_WIDTH = 355
  APP_DEFAULT_HEIGHT = 240
  HORIZONTAL_FRAME_DEFAULT_WIDTH = 355
  HORIZONTAL_FRAME_DEFAULT_HEIGHT = 45

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
    @jiraFrame = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => HORIZONTAL_FRAME_DEFAULT_WIDTH, :height => HORIZONTAL_FRAME_DEFAULT_HEIGHT)
      @jiraLabel = FXLabel.new(@jiraFrame,'JIRA:')
        @jiraLabel.font = FXFont.new(@app,_createFont())
    @jiraField = FXTextField.new(@jiraFrame, 30, :opts => LAYOUT_FILL|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)      
    
    @hFrame1 = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH ,:width => HORIZONTAL_FRAME_DEFAULT_WIDTH)
      @hFrame1Label = FXLabel.new(@hFrame1, "Task:" , :opts => LAYOUT_FIX_WIDTH, :width => 73)        
    @taskField = FXTextField.new(@hFrame1, 15, :opts => LAYOUT_FILL|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
    
    @detailsFrame =  FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => HORIZONTAL_FRAME_DEFAULT_WIDTH, :height => 90)
      @detailsData = FXDataTarget.new("")
      @detailsBox = FXGroupBox.new(@detailsFrame, 'Details:', GROUPBOX_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_Y|FRAME_GROOVE)
      detailsInsideFrame = FXHorizontalFrame.new(@detailsBox, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
      FXText.new(detailsInsideFrame, @detailsData, FXDataTarget::ID_VALUE, LAYOUT_FILL_X|LAYOUT_FILL_Y|SELECT_LINES|TEXT_SHOWACTIVE|TEXT_AUTOSCROLL)
      
    @vFrame1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
      @hFrame2 = FXHorizontalFrame.new(@vFrame1)
        @counterButton = FXButton.new(@hFrame2, "Start timer")
        @resetButton = FXButton.new(@hFrame2,"Reset timer")
        @settingsButton = FXButton.new(@hFrame2, "Settings")
        @saveButton = FXButton.new(@hFrame2,"Save")
   
        @counterLabel = FXLabel.new(@hFrame2,formatTime(@counterValue), :opts => FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
          @counterLabel.font = FXFont.new(@app,_createFont('Helvetica', 85, FONTWEIGHT_BOLD))
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
        Maconomy.new.save(Maconomy.getDefaultValues)
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
      if validateSaveAction
        begin
          #TODO GD.prepareRow gets called twice
          row = Ftt::GD.prepareRow(@taskField.text, @jiraField.text, _roundCounterValueToHours, Maconomy.match(@jiraField.text), @detailsData.value)
          confirmBox = FXMessageBox.new(getApp,"","The following row will be saved :\n #{row.inspect}",nil,MBOX_YES_NO).execute
          if confirmBox == 1
            Ftt::GD.save(@taskField.text, @jiraField.text, _roundCounterValueToHours, Maconomy.match(@jiraField.text), @detailsData.value)
            FXMessageBox.new(getApp,"","Success!",nil,MBOX_OK).execute
          end          
        rescue => e
          FXMessageBox.new(getApp,"Error",e.message,nil,MBOX_OK).execute
        end
      end      
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
  
  #rounds @counterValue to hours
  def _roundCounterValueToHours
    #DEBUGGING
    return 1
    _temp = @counterValue    
    #substract hours
    _h = (_temp / 3600.0).round_down
    _temp -= _h * 3600
    #if time left is less then 15min round to 0
    if _temp <= 900
      return _h
    end
    #if time left is less then 45min round to 0.5
    if _temp <= 2400
      return _h + 0.5
    end
    # 45 min < time left < 60 min round to 1h
    return _h + 1    
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
  
  # validate the Save button from the main dialog
  def validateSaveAction
    if _roundCounterValueToHours < 0.5
      FXMessageBox.new(getApp,"Warning","Get some work done first",nil,MBOX_OK).execute
      return false
    end
    if @taskField.text.strip.empty? === true
      FXMessageBox.new(getApp,"Warning","Task field is empty",nil,MBOX_OK).execute
      return false
    end
    if @jiraField.text.strip.empty? === true
      FXMessageBox.new(getApp,"Warning","JIRA field is empty",nil,MBOX_OK).execute
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
