class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #決まった英語を日本語に変換する関数
  #return 日本語訳
  def translateSceneToJP(text_en)
    translate_hash = {}
    translate_hash["Urban"] = "都会"
    translate_hash["Beach"] = "海辺"
    translate_hash["Water"] = "水"
    translate_hash["Restaurant"] = "nレストラン"
    translate_hash["Night Life"] = "夜景"
    translate_hash["Food"] = "n食事"
    translate_hash["Indoor"] = "屋内"
    translate_hash["Suburban"] = "郊外"
    translate_hash["Snow"] = "雪"
    translate_hash["River"] = "川"
    translate_hash["Rock Climbing"] = "山登り"
    translate_hash["Ocean"] = "海"
    translate_hash["Park"] = "公園"
    translate_hash["Sunset"] = "夕日"
    translate_hash["Desert"] = "荒野"
    translate_hash["Mountain"] = "山地"

    text_jp = ""

    if translate_hash.has_key?(text_en) == true
      text_jp = translate_hash[text_en]
      if text_jp.include?("n") == true
        text_jp = ""
      end
    end
    if text_jp == ""
      puts text_en
    end
    return text_jp
  end

  #calcurate 2 points distance
  #return distance[m]
  def calcDistance(lat1,lon1,lat2,lon2)
    a_lat = lat1.to_f * Math::PI / 180
    a_lon = lon1.to_f * Math::PI / 180
    b_lat = lat2.to_f * Math::PI / 180
    b_lon = lon2.to_f * Math::PI / 180

    latave = (a_lat + b_lat) / 2
    latidiff = a_lat - b_lat
    longdiff = a_lon - b_lon

    meridian = 6335439 / Math.sqrt((1 - 0.006694 * Math.sin(latave) * Math.sin(latave)) ** 3)

    primevertical = 6378137 / Math.sqrt(1 - 0.006694 * Math.sin(latave) * Math.sin(latave))

    x = meridian * latidiff
    y = primevertical * Math.cos(latave) * longdiff

    return Math.sqrt(x ** 2 + y ** 2)
  end

  #creating picture hash map
  def createHashPicture(activerecord_picture,current_lat,current_lon)
    hash_picture = {}
    hash_picture["url"] = activerecord_picture.url
    hash_picture["latitude"] = activerecord_picture.latitude
    hash_picture["longitude"] = activerecord_picture.longitude
    hash_picture["title"] = activerecord_picture.title
    hash_picture["description"] = activerecord_picture.description
    hash_picture["address"] = activerecord_picture.address
    hash_picture["date"] = activerecord_picture.date
    hash_picture["distance"] = "No data"
    if current_lat != nil or current_lat != "" or current_LAT == "LAT"
      hash_picture["distance"] = calcDistance(current_lat,current_lon,activerecord_picture.latitude,activerecord_picture.longitude)/1000
      hash_picture["distance"] = hash_picture["distance"].round(2)
    end
    return hash_picture
  end
end
