require "instagram"
require "uri"
require "foursquare2"
require 'timeout'


cid = "6b1516729cf8466581b0d87804222251"
csec = "e9c07e71ead141c5acb96df14b44ce45"
client = Instagram::Client.new(format: 'json',client_id: cid,client_secret: csec)

clientF = Foursquare2::Client.new(:client_id => 'HLAML1ZW2THM4HFB5FDRJJGMRVEJYHTRPWTJ55HXSGYCGLKU', :client_secret => 'YTAL1SQ2X53P3EW41ASLL21L2OK3WLWWN4Z3EOKNIQVIM4L1')

value = "4b297be1f964a520ad9f24e3"
elements = ARGV[0].split("+")
value = elements[0]
spot  = elements[1]
post  = elements[2]
address = elements[3]
detail = elements[4]
result = client.location_search(value)
output = ""

result.each{|k, v|
  k.each{ |kk,vv|
        if kk == "latitude"
          output = value + "+" + vv.to_s
        end
        if kk == "id"
          output = output + "+" + vv
        end
        if kk == "longitude"
          output = output + "+" + vv.to_s
        end
        if kk == "name"
          output = output + "+" + vv
        end
  }
}

if output != ""
  output = output + "+" + ARGV[0]
  File.open("IwateSpotsListWithInstaID.dat", 'a') {|file|
    file.write(output + "\n")
  }
end
