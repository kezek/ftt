module Ftt
  class Settings < FXDialogBox

    attr_reader :GUsername, :GPassword, :GSpreadsheetKey, :maconomyData, :Username
    def initialize(owner)
      # Invoke base class initialize function first
      super(owner, "Settings", DECOR_TITLE|DECOR_BORDER, :height => 500)
      hFrame1 = FXHorizontalFrame.new(self)
      vFrame1 = FXVerticalFrame.new(hFrame1)
      gUsernameLabel        = FXLabel.new(vFrame1, "Google username:",:padTop => 5)
      gPasswordLabel        = FXLabel.new(vFrame1, "Google password:", :padTop => 5)
      spreadsheetKeyLabel   = FXLabel.new(vFrame1, "Spreadsheet Key:", :padTop => 5)
      spreadsheetUsername   = FXLabel.new(vFrame1, "Username (used in sheet):", :padTop => 5)
      vFrame2 = FXVerticalFrame.new(hFrame1)
      # render the field
      @GUsername = FXTextField.new(vFrame2, 45,
      :opts => LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
      if Ftt::Config.instance.configured? == true
        # fetch config value
        gUsernameConfigValue = Ftt::Config.instance.getGUsername
        # display config value unless empty or nil
        unless gUsernameConfigValue.nil? or gUsernameConfigValue == ' ' or gUsernameConfigValue.empty?
          @GUsername.text = gUsernameConfigValue
        end
      end

      # render the field
      @GPassword = FXTextField.new(vFrame2, 45,
      :opts => TEXTFIELD_PASSWD|LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
      if Ftt::Config.instance.configured? == true
        # fetch config value
        gPasswordConfigValue = Ftt::Config.instance.getGPassword
        # display config value unless empty or nil
        unless gPasswordConfigValue.nil? or gPasswordConfigValue == ' ' or gPasswordConfigValue.empty?
          @GPassword.text = gPasswordConfigValue
        end
      end

      # render the field
      @GSpreadsheetKey = FXTextField.new(vFrame2, 45,
      :opts => LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
      if Ftt::Config.instance.configured? == true
        # fetch config value
        gSpreadsheetKeyConfigValue = Ftt::Config.instance.getGSpreadsheetKey
        # display config value unless empty or nil
        unless gSpreadsheetKeyConfigValue.nil? or gSpreadsheetKeyConfigValue == ' ' or gSpreadsheetKeyConfigValue.empty?
          @GSpreadsheetKey.text = gSpreadsheetKeyConfigValue
        end
      end

      #render the field
      @Username = FXTextField.new(vFrame2, 45,
      :opts => LAYOUT_CENTER_Y|LAYOUT_CENTER_X|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_ROW)
      if Ftt::Config.instance.configured? == true
        # fetch config value
        username = Ftt::Config.instance.getUsername
        unless username.nil? or username == ' ' or username.empty?
          @Username.text = username
        end
        # display config value unless empty or nill
      end

      hFrame2 = FXHorizontalFrame.new(self, :opts => LAYOUT_FILL_X|LAYOUT_FIX_HEIGHT, :height => 250)
      @maconomyData = FXDataTarget.new("")
      maconomyBox = FXGroupBox.new(hFrame2, "Maconomy Codes", GROUPBOX_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_Y|FRAME_GROOVE)
      maconomyFrame = FXHorizontalFrame.new(maconomyBox, FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y)
      # display db value if populated
      if Ftt::Config.instance.configured? == true
        maconomyCodes = Ftt::Config.instance.getMaconomyCodesCombined
        unless maconomyCodes.nil? or maconomyCodes == ' ' or maconomyCodes.empty?
          @maconomyData.value = maconomyCodes
        end
        #if first run then populate with default values
      else
        @maconomyData.value =  Ftt::Maconomy.getDefaultValues
      end
      # render element
      FXText.new(maconomyFrame, @maconomyData, FXDataTarget::ID_VALUE, LAYOUT_FILL_X|LAYOUT_FILL_Y|SELECT_LINES|TEXT_SHOWACTIVE|TEXT_AUTOSCROLL)
      hFrame3 = FXHorizontalFrame.new(self)
      acceptButton = FXButton.new(hFrame3, "Accept", nil, self, ID_ACCEPT,
      FRAME_RAISED|FRAME_THICK|LAYOUT_CENTER_Y)
      acceptButton.setDefault
      acceptButton.setFocus
      cancelButton = FXButton.new(hFrame3, "Cancel", nil, self, ID_CANCEL,
      FRAME_RAISED|FRAME_THICK|LAYOUT_CENTER_Y)
      FXLabel.new(hFrame3, "Note : place the current montly worksheet as the first one")
    end
  end
end