require "google_drive"

module Ftt
  class GD
    def self.login
      begin
        gusername = Ftt::Config.instance.getGUsername
        gpassword = Ftt::Config.instance.getGPassword
        @@session = GoogleDrive.login(gusername,gpassword)
      rescue => e
        Ftt::Config.instance.logger.error(e.message)
      end
    end

    def self.getSpreadsheet
      begin
        @@spreadsheet = @@session.spreadsheet_by_key(Ftt::Config.instance.getGSpreadsheetKey)
      rescue => e
        Ftt::Config.instance.logger.error(e.message)
      end
    end

    def self.getLatestWorksheet
      begin
        @@worksheet = getSpreadsheet.worksheets[0]
      rescue => e
        Ftt::Config.instance.logger.error(e.message)
      end
    end
  end
end
