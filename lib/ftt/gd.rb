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
    
    def self.prepareRow(task, jira, time, maconomy, details)
      @@row = Array[getCurrentDate, Ftt::Config.instance.getUsername, maconomy, task, jira, time, details]        
    end
    
    # TODO : finish implementation
    def self.save(task, jira, time, maconomy, details)
      #@@worksheet[1, 1] = "aaaaaa"
      #@@worksheet[1, 2] = "bbbbbb"
      prepareRow(task, jira, time, maconomy, details)
      rowIndex = getAvailableRowIndex
      index = -1
      for col in 1..@@worksheet.num_cols
        @@worksheet[rowIndex, col] = @@row[index += 1]
      end
      @@worksheet.save
    end
    
    #fetch current date in format D/M/Y
    def self.getCurrentDate
      Date.today.strftime("%d.%m.%Y")
    end
    
    def self.isEntryForCurrentDay?
      latestDate = @@worksheet[@@worksheet.num_rows, 1]
      if latestDate == getCurrentDate.to_s
        return true
      end
      
      false
    end
    
    def self.getAvailableRowIndex
      @@worksheet.num_rows + 1
    end
  end
end
