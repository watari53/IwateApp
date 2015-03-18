require "gogo_maps"
require "csv"

number = 0

open("IwatekenSpotsListShaped.csv") do |file|
  while l = file.gets
    array = l.chop.split(",")
    puts "--------------"
    puts array[2]
    begin
      LatLon = GogoMaps.get_latlng(array[2])
      CSV.open("IwateSpotsListWithLatLon.csv", 'a') do |writer|
        writer << [array[0], array[1], array[2],LatLon[:lat],LatLon[:lng]]
      end
    rescue
      CSV.open("IwateSpotsListWithLatLon.csv", 'a') do |writer|
        writer << [array[0], array[1], array[2],"no","no"]
      end
    end
  end
end
