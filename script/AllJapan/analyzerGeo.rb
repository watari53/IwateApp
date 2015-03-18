require 'net/http'
require 'json'
require "uri"
require "rest_client"

RestClient.proxy = ENV['http_proxy']

@app_id = "dj0zaiZpPXc1RjNMNDBOYWh0dSZzPWNvbnN1bWVyc2VjcmV0Jng9M2I-"
@base_url_geo = "http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder"
@base_url_rev_geo = "http://reverse.search.olp.yahooapis.jp/OpenLocalPlatform/V1/reverseGeoCoder"


def geocode(address)
  address = URI.encode(address)
  hash = Hash.new

  reqUrl = "#{@base_url_geo}?appid=#{@app_id}&query=#{address}&output=json"
  response = Net::HTTP.get_response(URI.parse(reqUrl))

  case response
  when Net::HTTPSuccess then
    data = JSON.parse(response.body)
    coordinates = data['Feature'][0]['Geometry']['Coordinates'].split(/,\s?/)
    hash['lat'] = coordinates[1].to_f # 緯度
    hash['lng'] = coordinates[0].to_f # 経度
  else
     hash['lat'] = 0.00
    hash['lng'] = 0.00
  end

  return hash
end

def reverse_geocode(coordinates)
  lat = coordinates['lat'].to_s
  lng = coordinates['lng'].to_s

  reqUrl = "#{@base_url_rev_geo}?appid=#{@app_id}&lat=#{lat}&lon=#{lng}&output=json"

  response = Net::HTTP.get_response(URI.parse(reqUrl))

  case response
  when Net::HTTPSuccess then
    data = JSON.parse(response.body)
    address = data['Feature'][0]['Property']['Address']
  else 
    address = "no"
  end
end

coordinates = geocode("東京都港区芝公園4‐2‐8")
p coordinates
p reverse_geocode(coordinates)
