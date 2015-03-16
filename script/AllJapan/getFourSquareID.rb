require "csv"
require "foursquare2"

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

client = Foursquare2::Client.new(:client_id => 'HLAML1ZW2THM4HFB5FDRJJGMRVEJYHTRPWTJ55HXSGYCGLKU', :client_secret => 'YTAL1SQ2X53P3EW41ASLL21L2OK3WLWWN4Z3EOKNIQVIM4L1')

venues_ids = []
venues_id_name = []

open("IwateSpotsListWithLatLon.csv") do |file|
  while l = file.gets
    array = l.chop.split(",")
    lat = array[3]
    lon = array[4]
    spot = array[0]

    if lat == "no"
      next
    end

    result = client.search_venues(:ll => "#{lat},#{lon}",:radius => "1000",:limit => "50",:v => '20140208')

    result["venues"].each{|k, v|
      tmp = []
      k.each { |kk,vv|
        #puts kk
        #puts vv
        if venues_ids.include?(vv) == false and kk == "id"
          #venues_ids.push(vv)
          tmp << vv
        end
        if venues_ids.include?(vv) == false and kk == "name"
          if same(spot,vv) == true
            #puts spot + "-" + vv
            tmp << vv
          else

          end
        end
      }
      if tmp.size == 2
        venues_ids << tmp[0]
      end
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
