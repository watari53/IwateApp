#!/bin/sh
# ファイルを1行ずつ読み込んで表示
TESTFILE=IwateSpotsListID.csv
while read line
do
  ruby getInstagramID_FqID.rb $line
done < $TESTFILE
