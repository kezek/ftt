require "google_drive"

module Ftt
  class GD
    def self.login
      gusername = Ftt::Config.instance.getGUsername
      gpassword = Ftt::Config.instance.getGPassword
      GoogleDrive.login(gusername,gpassword)
    end
  end
end
