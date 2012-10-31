require_relative './../config'

class Maconomy  

  MACONOMY_TABLE = 'maconomy'

  public
  def self.getDefaultValues
<<eos
DLT,60040099
IFB,60040098
IRD,60040096
CPX,60040094
eos
  end

  def save(multiLineString)
    Db.instance.execute("CREATE table if not exists #{MACONOMY_TABLE} (pattern TEXT UNIQUE, code TEXT)")
    multiLineString.each_line do |row|
      values = row.split(',')
      #check if there are 2 values
      if values.count
        #save pair to maconomy table in db
        Db.instance.execute("INSERT OR REPLACE INTO #{MACONOMY_TABLE} values ( ?, ? )",
        values.first.encode('UTF-8').strip,values.last.encode('UTF-8').strip)
      end
    end
    Ftt::Config.instance.setMaconomyCodesCombined(multiLineString)
  end

end