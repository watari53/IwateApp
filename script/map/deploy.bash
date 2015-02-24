#execute in app root directory

: <<'#__CO__'
echo "rake db:reset"
rake db:reset

echo "rake db:migrate"
rake db:migrate

echo "rm previous assets & assets:precompile env production"
rm public/assets/*-*.gz public/assets/*-*.css public/assets/*-*js
rake assets:precompile RAILS_ENV=production

echo "in script"
cd script

echo "in map"
cd map
#__CO__

echo "make csv file from si.list > si.csv"
ruby make_areaCSV_from_list.rb

# insert header > si.csv manually

echo "make_area.rb"
ruby make_area_from_areaCSV.rb si.csv # areaテーブルの作成

: <<'#__CO__'
echo "in script"
cd ../

echo "registerAlbumsToDBfromCSV.rb"
ruby registerAlbumsToDBfromCSV.rb

echo "registerPicturesToDB.sh > registerPicturesToDB_log.txt"
sh registerPicturesToDB.sh > registerPicturesToDB_log.txt

#__CO__

echo "in db"
cd ../../db/

echo "cp development.sqlite3 production.sqlite3"
cp development.sqlite3 production.sqlite3
cd ../

