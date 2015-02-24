require "csv"
require "foursquare2"

client = Foursquare2::Client.new(:client_id => 'HLAML1ZW2THM4HFB5FDRJJGMRVEJYHTRPWTJ55HXSGYCGLKU', :client_secret => 'YTAL1SQ2X53P3EW41ASLL21L2OK3WLWWN4Z3EOKNIQVIM4L1')

venues_ids = []

open("IwateSpotsListWithLatLon.csv") do |file|
  while l = file.gets
    array = l.chop.split(",")
    lat = array[3]
    lon = array[4]

    if lat == "no"
      next
    end

    result = client.search_venues(:ll => "#{lat},#{lon}",:radius => "100000",:limit => "50",:v => '20140208')

    result["venues"].each{|k, v|
      k.each { |kk,vv|
        #puts kk
        #puts vv
        if venues_ids.include?(vv) == false and kk == "id"
          venues_ids.push(vv)
        end
      }
      #puts "*********"
    }

    #puts result["categories"]
    #puts "--------"
    #puts ""
  end
end

File.open("IwateSpotsListID.csv", 'a') {|file|
  venues_ids.each do |id|

    file.write(id + "\n")
  end
}
