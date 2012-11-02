class FirstTime < FXMessageBox
  def initialize(owner)
    super(owner, "Yo dude","Seems like you're a first timer. Do you want to configure the app ?",nil,MBOX_YES_NO)
  end
end

class GoogleDriveConnectError < FXMessageBox
  def initialize(owner)
    super(owner, "Warning", "Could not connect to Google Drive. Try again.",nil,MBOX_OK)
  end
end

class GoogleDriveInvalidSpreadsheet < FXMessageBox
  def initialize(owner)
    super(owner, "Warning", "Could not retrieve worksheet. Check the spreadsheet key.",nil,MBOX_OK)
  end
end
