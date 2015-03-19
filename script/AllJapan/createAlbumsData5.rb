require "uri"
require "sqlite3"
require 'net/http'
require 'json'

@app_id = "dj0zaiZpPXc1RjNMNDBOYWh0dSZzPWNvbnN1bWVyc2VjcmV0Jng9M2I-"
@base_url_rev_geo = "http://reverse.search.olp.yahooapis.jp/OpenLocalPlatform/V1/reverseGeoCoder"

def checkJP(text)
  japanese_regex = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  if japanese_regex =~ text
    return true
  else
    return false
  end
end

def same(text1,text2)
  not_match = 0
  text1.split(//).each do |ch|
    if checkJP(ch) == false
      next
    end
    if text2.include?(ch) == false
      not_match = 1
      break
    end
  end
  if not_match == 1
    return false
  end

  text2.split(//).each do |ch|
    if checkJP(ch) == false
      next
    end
    if text1.include?(ch) == false
      not_match = 1
      break
    end
  end

  if not_match == 1
    return false
  else
    return true
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

def getJaranSpots
  jaranSpotsTmp = {}
  open("IwateSpotsListWithLatLon.dat") do |file|
    while l = file.gets
      array = l.chop.split("+")
      lat = array[4]
      lon = array[5]
      spot = array[0]
      detail = array[3]
      if lat == "no"
        next
      end
      jaranSpotsTmp[spot] = detail
    end
  end
  return jaranSpotsTmp
end

def getDetail(text,spots)


end

prefectural = ARGV[0]
split_unit =  ARGV[1]
jaranSpots = getJaranSpots

open("IwateSpotsListWithInstaID.dat") do |file|
  while l = file.gets
    array = l.chop.split("+")
    latitude = array[1]
    album_id = array[2]
    longitude = array[3]
    title = array[4]
    representative_picture = 1

    area = "No Data"
    address = "No Data"
    detail = "No Data"
    description = "No Data"

    address = reverseGeocode(latitude, longitude)

    if address.include?(prefectural) and address.include?(split_unit)
      area = address.split(prefectural)[1].split(split_unit)[0] + split_unit
    end

    if jaranSpots.has_key?(title) == true
      detail = jaranSpots[title]
      description = jaranSpots[title].split("。")[0]
    end

    puts title
    puts album_id
    puts latitude
    puts longitude
    puts address
    puts area
    puts description
    puts detail
    puts "---------------"

    line = title + "+" + album_id + "+" + latitude + "+" + longitude +"+" + address +"+" + area + "+" + description + "+" + detail

    File.open("AlbumData.dat", 'a') { |file|
      file.write(line + "\n")
    }

  end
end
