require "google_drive"
require 'date'

module Ftt
  class GD
    def self.login
      begin
        gusername = Ftt::Config.instance.getGUsername
        gpassword = Ftt::Config.instance.getGPassword
        @@session = GoogleDrive.login(gusername,gpassword)
      rescue => e
        Ftt::Config.instance.logger.error(e.message)
        raise e
      end
    end

    def self.getSpreadsheet
      begin
        @@spreadsheet = @@session.spreadsheet_by_key(Ftt::Config.instance.getGSpreadsheetKey)
      rescue => e
        Ftt::Config.instance.logger.error(e.message)
        raise e
      end
    end

    def self.getLatestWorksheet
      begin
        @@worksheet = getSpreadsheet.worksheets[0]
      rescue => e
        Ftt::Config.instance.logger.error(e.message)
        raise e
      end
    end
    
    # TODO : finish implementation
    def self.save
      @@worksheet[1, 1] = "aaaaaa"
      @@worksheet[1, 2] = "bbbbbb"
      @@worksheet.save
    end
    
    #fetch current date in format D/M/Y
    def self.getCurrentDate
      Date.today.strftime("%d.%m.%Y")
    end  
  end
end
