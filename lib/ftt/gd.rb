require "google_drive"

module Ftt
  class GD
    def self.login
      gusername = Ftt::Config.instance.getGUsername
      gpassword = Ftt::Config.instance.getGPassword
      @@session = GoogleDrive.login(gusername,gpassword)
    end

    def self.getSpreadsheet
      @@spreadsheet = @@session.spreadsheet_by_key(Ftt::Config.instance.getGSpreadsheetKey)
    end

    def self.getLatestWorksheet

    end
  end
end
