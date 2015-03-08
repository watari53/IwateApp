onlyHasShi = []

open("final.csv") do |file|
 while l = file.gets
   array = l.chop.split(",")
   address = array[5]

   if address == nil
     next
   end

   if address.include?("岩手県") and address.include?("市")
     begin
      shi = address.split("市")[0].split("岩手県")[1] + "市"
     rescue
       next
     end
      onlyHasShi_tmp = []
      onlyHasShi_tmp[0] = array[0]
      onlyHasShi_tmp[1] = array[5]
      onlyHasShi_tmp[2] = array[2]
      onlyHasShi_tmp[3] = array[3]
      onlyHasShi_tmp[4] = array[1]
      onlyHasShi_tmp[5] = shi
      onlyHasShi_tmp[6] = array[6]
      onlyHasShi_tmp[7] = array[7]
      onlyHasShi << onlyHasShi_tmp
   end
 end
end

onlyHasShi.each do |e|
  begin
    puts e[0] + "," + e[1] + "," + e[2] + "," + e[3] + "," + e[4] + "," + e[5] + "," + e[6] + "," + e[7]
  rescue
    next
  end
end
