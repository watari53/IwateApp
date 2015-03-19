#!/bin/sh
# ファイルを1行ずつ読み込んで表示
TESTFILE=AlbumData.dat

while read line
do
  insta_location_id=`echo ${line} | cut -d'+' -f 2`
  echo $insta_location_id
  ruby getInstagramWithLocationID.rb $insta_location_id
done < $TESTFILE
