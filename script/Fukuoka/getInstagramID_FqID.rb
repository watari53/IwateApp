require "instagram"
require "uri"
require "sqlite3"
require "gogo_maps"
require "foursquare2"
require 'timeout'


cid = "6b1516729cf8466581b0d87804222251"
csec = "e9c07e71ead141c5acb96df14b44ce45"
client = Instagram::Client.new(format: 'json',client_id: cid,client_secret: csec)
lat = "35.443708"
lon = "139.638026"
ratitude = "5000"

clientF = Foursquare2::Client.new(:client_id => 'HLAML1ZW2THM4HFB5FDRJJGMRVEJYHTRPWTJ55HXSGYCGLKU', :client_secret => 'YTAL1SQ2X53P3EW41ASLL21L2OK3WLWWN4Z3EOKNIQVIM4L1')

value = "4b297be1f964a520ad9f24e3"
value = ARGV[0]
result = client.location_search(value)
output = ""
result.each{|k, v|
  k.each{ |kk,vv|
        if kk == "latitude"
          output = value + "," + vv.to_s
        end
        if kk == "id"
          output = output + "," + vv
        end
        if kk == "longitude"
          output = output + "," + vv.to_s
        end
        if kk == "name"
          output = output + "," + vv
        end
      }
   }

if output != ""
  puts output
end

=begin
open("YokohamaSpotsListID1.csv") do |file|
  while l = file.gets
    result = client.location_search(l.to_s)
    puts result
    puts l
    result.each{|k, v|
      k.each{ |kk,vv|
        if kk == "id"
          puts kk + "," + vv
        end
      }
   }
  end
end


=begin
open("YokohamaSpotsListIDworking.csv") do |file|
  while l = file.gets
    result = client.location_search("#{l}")
    if result == []
      puts "no-" + l
    else
      puts l
    end
  end
end

=begin
open("YokohamaSpotsListID.csv") do |file|
  while l = file.gets
    begin
      timeout(3) {
        result = client.location_search(l)
      }
    rescue Timeout::Error => e
      puts "no" + l
    rescue => e
      puts l
    end
  end
end
=end
