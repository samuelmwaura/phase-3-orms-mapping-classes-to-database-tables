class Song
  attr_accessor :name ,:album,:id

  def initialize(name:, album:, id:nil)
  @id = id
  @name = name
  @album = album
  end
   
   def self.create_table  #The less than sin is syntax for creating a multiple line string.
    sql =  <<-SQL  
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
        )
        SQL
    DB[:conn].execute(sql)  #DB[:conn] is an envrionment variable in another file.Execute is a method
  end

#method to save created song instance to the db
  def save
    sql = <<-SQL
    INSERT INTO songs (name, album) VALUES (?,?)
    SQL

    DB[:conn].execute(sql,self.name,self.album) #save a song instance to the db
   
    #get the id of the last saved song and save it to the ruby instance for later use.
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    self  #returning the update ruby instance 
  end

#method that combines creating and saving an object instance
  def self.create(name:,album:)
    song = Song.new(name: name,album: album)
    song.save   #remember that the return value for this is the creates object instance updated with its Id in the db
  end

  end