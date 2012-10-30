class Maconomy
    
  MACONOMY_TABLE = 'maconomy'
  
  public
  def setDefaultValues
    default = <<-eos 
    DLT,60040099
    IFB,60040098
    IRD,60040096
    CPX,60040094
    eos
  end
  
  def save(multiLineString)
    multiLineString.each_line do |row|
      values = row.split(',')
      #check if there are 2 values
      if values.count
        #save pair to maconomy table in db
        Db.instance.execute("INSERT OR REPLACE INTO #{MACONOMY_TABLE} values ( ?, ? )",
                            values.first.encode('UTF-8'),values.last.encode('UTF-8'))
      end
    end
  end
end