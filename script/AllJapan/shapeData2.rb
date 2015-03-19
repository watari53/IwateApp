require "gogo_maps"
require "csv"
require "uri"
require "sqlite3"
require 'net/http'
require 'json'

number = 0

@app_id = "dj0zaiZpPXc1RjNMNDBOYWh0dSZzPWNvbnN1bWVyc2VjcmV0Jng9M2I-"
@base_url_geo = "http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder"

def geocode(address)
  address = URI.encode(address)
  hash = Hash.new

  reqUrl = "#{@base_url_geo}?appid=#{@app_id}&query=#{address}&output=json"
  response = Net::HTTP.get_response(URI.parse(reqUrl))

  case response
  when Net::HTTPSuccess then
    data = JSON.parse(response.body)
    if data["Feature"] == nil
      hash['lat'] = "no"
      hash['lng'] = "no"
    return hash
    end
    coordinates = data['Feature'][0]['Geometry']['Coordinates'].split(/,\s?/)
    hash['lat'] = coordinates[1].to_f # 緯度
    hash['lng'] = coordinates[0].to_f # 経度
  else
    hash['lat'] = "no"
    hash['lng'] = "no"
  end
  return hash
end

def checkJP(text)
  japanese_regex = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  if japanese_regex =~ text
    return true
  else
    return false
  end
end

open("IwateSpotsList_with_detail.dat") do |file|
  while l = file.gets
    array = l.chop.split("+")

    spot_title = array[0]
    post = ""
    address = array[1]
    if address.include?("　") == true
      address = array[1].split("　")[1]
      if address.include?("観光") == true
        address = address.split("観光")[0]
      end
      post = array[1].split("　")[0]
    end
    detail = array[2]

    LatLon = geocode(address)

    if LatLon["lat"] != "no"
      line = spot_title + "+" + post + "+" + address + "+" + detail + "+" + LatLon["lat"].to_s + "+" + LatLon["lng"].to_s
      File.open("IwateSpotsListWithLatLonY.dat", 'a') { |file|
        file.write(line + "\n")
      }
    end
  end
end
