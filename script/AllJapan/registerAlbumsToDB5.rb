require "uri"
require "sqlite3"
require "gogo_maps"
require 'net/http'
require 'json'

@app_id = "dj0zaiZpPXc1RjNMNDBOYWh0dSZzPWNvbnN1bWVyc2VjcmV0Jng9M2I-"
@base_url_rev_geo = "http://reverse.search.olp.yahooapis.jp/OpenLocalPlatform/V1/reverseGeoCoder"

def getAddress(lat, lng)
  begin
    return GogoMaps.get_address(lat, lng)  #緯度経度を住所へ変換
  rescue
    puts "sleep 10 sec..."
    sleep(10)
    getAddress(lat, lng)
  end
end

def reverseGeocode(_lat,_lng)
  lat = _lat.to_s
  lng = _lng.to_s
  reqUrl = "#{@base_url_rev_geo}?appid=#{@app_id}&lat=#{lat}&lon=#{lng}&output=json"

  response = Net::HTTP.get_response(URI.parse(reqUrl))

  case response
  when Net::HTTPSuccess then
    data = JSON.parse(response.body)
    address = data['Feature'][0]['Property']['Address']
  else
    address = "no"
  end
  return address
end

prefectural = ARGV[0]
split_unit =  ARGV[1]

open("FqID_InstaID.csv") do |file|
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
    address = reverseGeocode(latitude, longitude)

    if address.include?(prefectural) and address.include?(split_unit)
      area = address.split(prefectural)[1].split(split_unit)[0] + split_unit
    end
    puts address
    puts area
    puts "----------"

    line = title + "," + album_id + "," + latitude + "," + longitude +"," + address +"," + area

    File.open("AlbumDataY.csv", 'a') { |file|
      file.write(line + "\n")
    }

    post_id = post_id.to_i + 1
  end
end
