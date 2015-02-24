#execute in app root directory
rake db:reset
rake db:migrate
cd script
cd map
ruby make_area.rb # areaテーブルの作成
cd ../Iwate
ruby registerAlbumsToDBfromCSV.rb
sh registerPicturesToDB.sh
cd ../../db/
cp development.sqlite3 production.sqlite3
rake assets:precompile RAILS_ENV=production
