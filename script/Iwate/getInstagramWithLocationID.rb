require "instagram"
require "uri"
require "sqlite3"
require "gogo_maps"
require "rekognize"

RestClient.proxy = ENV['http_proxy']

api_key_list = ["8p96nEi1Bkb2u01G",""]
api_secret_list = ["3yQRadcFPBiG4fRe",""]
array_number = 0
api_key    = api_key_list[array_number]
api_secret = api_secret_list[array_number]
rekognize_client = Rekognize::Client::Base.new(api_key:api_key,api_secret:api_secret)

cid = "6b1516729cf8466581b0d87804222251"
csec = "e9c07e71ead141c5acb96df14b44ce45"
client = Instagram::Client.new(format: 'json',client_id: cid,client_secret: csec)

insta_spot_id =ARGV[0]

db_name = "../../db/development.sqlite3"
db = SQLite3::Database.new(db_name)

picture_id = db.execute("select * from pictures").size + 1
scene_id   = db.execute("select * from scenes").size + 1
tag_id   = db.execute("select * from tags").size + 1
tagcount_id   = db.execute("select * from tagcounts").size + 1
scenecount_id   = db.execute("select * from scenecounts").size + 1


begin
  response = client.location_recent_media(insta_spot_id).to_json
rescue
  response = nil  # TODO: exception handling
end

#この場所付近で投稿された情報はないので、プログラムを終了させる
if response == nil
  exit
end

json_data = JSON.parser.new(response)
hash= json_data.parse()

hash.each do |post|
  picture_url = post["images"]["standard_resolution"]["url"]        #写真URL

  #緯度経度情報がないものは無視する
  if post["location"] == nil
    next
  end

  #写真に顔が写っていない場合は無視する
  face_infor = rekognize_client.face_detect(urls:picture_url,jobs:'face_part_aggressive')
  if face_infor["face_detection"] != []
    next
  end

  lat = post["location"]["latitude"].to_f                           #投稿された写真のlat
  lon = post["location"]["longitude"].to_f                          #投稿された写真のlon
  #address = GogoMaps.get_address(lat, lon)                         #緯度経度を住所へ変換

  date = Time.at(post["created_time"].to_f)                         #投稿された時間
  if post["caption"] != nil
    description = post["caption"]["text"]                           #投稿者の一言コメント
  end
  location_name = post["location"]["name"]                          #位置情報からの場所の名前
  tags = post["tags"]                                               #投稿された写真のタグの配列

  #既に登録されているデータか否かをチェックする
  existed = db.execute("select * from pictures where url == '#{picture_url}'").size
  if existed != 0
    puts "既に登録されている写真です"
puts "/"
    next
  end

  #テーブルへ保存する
  db.transaction do
    #picturesテーブルへデータ保存
    sql = "insert into pictures values(?,?,?,?,?,?,?,?,?,?,?)"
    db.execute(sql,picture_id.to_i,nil,nil,date.to_s,picture_url,lat.to_f,lon.to_f,nil,location_name,insta_spot_id,description)
    puts(sql,picture_id.to_i,nil,nil,date.to_s,picture_url,lat.to_f,lon.to_f,nil,location_name,insta_spot_id,description)
puts "/"

    #sceneテーブル scenecountテーブルへデータ保存
    scenes = rekognize_client.scene_understanding(urls:picture_url,jobs:'scene_understanding')
    scenes["scene_understanding"].each do |scene|
      label = scene["label"]
      score = scene["score"]

      existed_scene = db.execute("select * from scenes where text == '#{label}'").size
      if existed_scene != 0
        #すでに登録されているシーンの場合
        number = db.execute("select count from scenecounts where text == '#{label}'")
        number = number[0][0].to_i + 1
        db.execute("update scenecounts set count ='#{number}' where text == '#{label}'")
        puts("update scenecounts set count ='#{number}' where text == '#{label}'")
puts "/"
      else
        #まだ登録されていないシーンの場合
        sql = "insert into scenecounts values(?,?,?,?,?)"
        db.execute(sql,scenecount_id.to_i,label,1,nil,nil)
        puts(sql,scenecount_id.to_i,label,1,nil,nil)
puts "/"
        scenecount_id = scenecount_id.to_i + 1
      end

      sql = "insert into scenes values(?,?,?,?,?,?)"
      db.execute(sql,scene_id.to_i,picture_id.to_i,label,nil,nil,score.to_f)
      puts(sql,scene_id.to_i,picture_id.to_i,label,nil,nil,score.to_f)
puts "/"
      scene_id   = scene_id.to_i + 1
    end

    #tagsテーブル tagcountテーブルへデータ保存
    tags.each do |tag|
      existed_tag = db.execute("select * from tags where text == '#{tag}'").size
      if existed_tag != 0
        #すでに登録されているタグの場合
        count = db.execute("select count from tagcounts where text == '#{tag}'")
        count = count[0][0].to_i + 1
        db.execute("update tagcounts set count ='#{count}' where text == '#{tag}'")
        puts("update tagcounts set count ='#{count}' where text == '#{tag}'")
puts "/"
      else
        #まだ登録されていないタグの場合
        sql = "insert into tagcounts values(?,?,?,?,?)"
        db.execute(sql,tagcount_id.to_i,1,nil,nil,tag)
        puts(sql,tagcount_id.to_i,1,nil,nil,tag)
puts "/"
        tagcount_id = tagcount_id.to_i + 1
      end
      sql = "insert into tags values(?,?,?,?,?)"
      db.execute(sql,tag_id.to_i,nil,nil,picture_id,tag)
      puts(sql,tag_id.to_i,nil,nil,picture_id,tag)
puts "/"
      tag_id = tag_id.to_i + 1
    end
    picture_id = picture_id.to_i + 1
  end
end

db.close

