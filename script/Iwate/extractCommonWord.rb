jaran_spot_file = "IwateSpotsList_with_detail.csv"
insta_spot_file = "AlbumDataCommonJaranWithShi.csv"

jaran_list = {}
insta_list = {}

commons = []

open(insta_spot_file) do |file|
  while l = file.gets
    array = l.chop.split(",")
    title = array[0]
    insta_list[title] = l
  end
end

open(jaran_spot_file) do |file|
  while l = file.gets
    array = l.chop.split(",")
    title = array[0]
    jaran_list[title] = l
   # puts title
  end
end

insta_list.each do |insta_key,insta_value|
  jaran_list.each do |jaran_key,jaran_value|
    if insta_key == jaran_key
      text = ""
      insta_value.chop.split(",").each do |col|
        text = text + col + ","
      end
      text = text + jaran_value.split(",")[2].split("。")[0] + "," + jaran_value.split(",")[2] #description and detail
      #puts text
      commons << text
    end
  end
end

commons.each do |value|
  puts value
end
