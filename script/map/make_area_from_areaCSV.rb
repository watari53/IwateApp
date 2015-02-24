require "uri"
require "sqlite3"


db_name = "../../db/production.sqlite3"

db = SQLite3::Database.new(db_name)
 open(ARGV[0]) do |file|
   id = -1
  while line = file.gets
   id += 1
   next if id == 0
   array = line.chop.split(",")
   area = array[0]
   ja   = array[1]
   lat  = array[2]
   lng  = array[3]
   puts area + ":" + ja + ":" + lat + ":" + lng

   db.transaction do
    sql = "insert into areas values(?,?,?,?,?,?,?)"
    db.execute(sql, id.to_i, area, ja, lat, lng, nil, nil)
   end
  end
 end
db.close
