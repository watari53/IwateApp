require "uri"
require "sqlite3"
require "gogo_maps"

def getAddress(lat, lng)
  begin
    return GogoMaps.get_address(lat, lng)  #緯度経度を住所へ変換
  rescue
    puts "sleep 10 sec..."
    sleep(10)
    getAddress(lat, lng)
  end
end

#db_name = "../db/development.sqlite3"
#db = SQLite3::Database.new(db_name)

#post_id = db.execute("select * from albums").size + 1

open("fqID_instaID_tmp.csv") do |file|
  while l = file.gets
    array = l.chop.split(",")
    latitude = array[1]
    album_id = array[2]
    longitude = array[3]
    title = array[4]
    representative_picture = 1
    area = ""
    #address = ""

    puts title
    puts album_id
    puts latitude
    puts longitude
    address = getAddress(latitude, longitude)
    if address.include?("神奈川県横浜市")
      area = address.split("神奈川県横浜市")[1].split("区")[0] + "区"
    end
    puts address
    puts area
    puts "----------"
		line = title + "," + album_id + "," + latitude + "," + longitude +"," + 
						address +"," + area

		File.open("AlbumData.csv", 'a') {|file|
	 			file.write(line + "\n")
		}

    #Albumsテーブルへデータ保存
 #   db.transaction do
  #    sql = "insert into albums values(?,?,?,?,?,?,?,?,?,?)"
   #   db.execute(sql,post_id.to_i,title,address,latitude.to_f,longitude.to_f,nil,nil,representative_picture,album_id,area)
      post_id = post_id.to_i + 1
    #end
  end
end

db.close
