require "uri"
require "sqlite3"

applicationID = 2 # => 岩手県アプリで利用することを意味する

db_name = "../../db/development.sqlite3"
db = SQLite3::Database.new(db_name)

post_id = db.execute("select * from albums").size + 1

open("AlbumDataCommonJaranWithShi.csv") do |file|
  while l = file.gets
    array = l.chop.split(",")
  title = array[0]
    album_id = array[1]
    latitude = array[2]
    longitude = array[3]
    address = array[4]
    area = array[5]
    representative_picture = 1

  next if area == nil

    puts title
    puts album_id
    puts latitude
    puts longitude
    puts address
    puts area
    puts "----------"
  line = title + "," + album_id + "," + latitude + "," + longitude +"," + address + "," + area

    #Albumsテーブルへデータ保存
    db.transaction do
      sql = "insert into albums values(?,?,?,?,?,?,?,?,?,?,?)"
      db.execute(sql,post_id.to_i,title,address,latitude.to_f,longitude.to_f,nil,nil,representative_picture,album_id,area,applicationID)
      post_id = post_id.to_i + 1
    end
  end
end

db.close
