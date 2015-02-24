onlyHasShi = []

open("AlbumDataShaped.csv") do |file|
 while l = file.gets
   array = l.chop.split(",")
   address = array[2]
   if address.include?("福岡市") and address.include?("区")
      shi = address.split("福岡市")[1].split("区")[0] + "区"
      onlyHasShi_tmp = []
      onlyHasShi_tmp[0] = array[0]
      onlyHasShi_tmp[1] = array[1]
      onlyHasShi_tmp[2] = array[2]
      onlyHasShi_tmp[3] = array[3]
      onlyHasShi_tmp[4] = array[4]
      onlyHasShi_tmp[5] = shi
      onlyHasShi << onlyHasShi_tmp
   end
 end
end

onlyHasShi.each do |e|
  puts e[0] + "," + e[1] + "," + e[2] + "," + e[3] + "," + e[4] + "," + e[5]
end
