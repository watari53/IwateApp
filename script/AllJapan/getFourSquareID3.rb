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

def includeCheck(text,keywords)
  include_jp = 0
  keywords.each do |k|
    not_match = 0

    text.split(//).each do |ch|
      if checkJP(ch) == false
        next
      end
      include_jp = 1
      if k.include?(ch) == false
        not_match = 1
        break
      end
    end

    if not_match == 0 and include_jp == 1
      #puts text + "*" + k
      return true
    end
  end
  return false
end

client = Foursquare2::Client.new(:client_id => 'HLAML1ZW2THM4HFB5FDRJJGMRVEJYHTRPWTJ55HXSGYCGLKU', :client_secret => 'YTAL1SQ2X53P3EW41ASLL21L2OK3WLWWN4Z3EOKNIQVIM4L1')

venues_ids = []
venues_id_name = []

jaranSpots = []
spotsInformation = {}


open("IwateSpotsListWithLatLon.dat") do |file|
  while l = file.gets
    array = l.chop.split("+")
    lat = array[4]
    lon = array[5]
    spot = array[0]
    if lat == "no"
      next
    end

    jaranSpots << spot

  end
end


open("IwateSpotsListWithLatLon.dat") do |file|
  while l = file.gets
    array = l.chop.split("+")
    lat = array[4].to_f
    lon = array[5].to_f
    spot = array[0]
    post = array[1]
    address = array[2]
    detail = array[3]
    description = detail.split("。")[0]

    if lat == "no"
      next
    end

    result = client.search_venues(:ll => "#{lat},#{lon}",:radius => "100000000",:limit => "50",:v => '20140208')

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
          if includeCheck(vv,jaranSpots) == true
            #puts spot + "-" + vv
            tmp << vv
          else

          end
        end
      }
      if tmp.size == 2
        if venues_ids.include?(tmp[0]) == false
          venues_ids << tmp[0]
          tmp_infor = []
          tmp_infor << spot
          tmp_infor << post
          tmp_infor << address
          tmp_infor << detail
          spotsInformation[tmp[0]] = tmp_infor
        end
      end
    }

    #puts result["categories"]
    #puts "--------"
    #puts ""
  end
end


File.open("IwateSpotsListFqID.dat", 'a') {|file|
  venues_ids.each do |id|
    line = id
    if spotsInformation.has_key?(id) == true
      spotsInformation[id].each do |element|
        line = line + "+" + element.to_s
      end
    end
    if line.include?("すべての基本情報を見る") == false
      file.write(line + "\n")
    end
  end
}
