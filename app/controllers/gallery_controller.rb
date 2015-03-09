class GalleryController < ApplicationController

  def home

    near_threshold = 2000 #[m]　現在地から近いアルバムの距離に関するしきい値
    tag_max_number = 20

    @current_lat = params[:lat] #現在位置の緯度
    @current_lon = params[:lon] #現在位置の経度
    puts @current_lat

    @current_lat = "39.680156" #現在位置の緯度
    @current_lon = "141.133767" #現在位置の経度


    @selected_word = ""  #選択されたラベルがあれば、格納する。そのラベルの色を変化させ、押されていることを伝える

    @selected_tab  = 1 #選択されたタブ情報を格納する

    if params[:pagination_number_near] != nil
      @selected_near_page = params[:pagination_number_near]
    end
    if params[:pagination_number_tag] != nil
      @selected_tag_page = params[:pagination_number_tag]
    end
    if params[:pagination_number_scene] != nil
      @selected_scene_page = params[:pagination_number_scene]
    end


    @pictures = []
    @tags = []
    @scenes = []
    @near_albums_title_list = {}

    #近くのアルバムタグリストを作成
    near_albums = calcNearAlbumsFromCurrentPosition(@current_lat,@current_lon,near_threshold)
    selected_near_number = 0
    near_albums.each do |album|
      count = Picture.where(album_id:album.album_id).size
      if count == 0
        next
      end
      @near_albums_title_list[album.album_id] = "#{album.title}"
    end

    #場面タグリストを作成
    scenecounts = Scenecount.where('count > ?',10).order("count DESC").limit(tag_max_number)
    scenes = searchTableOr(Scene,"text",scenecounts)
    selected_scene_number = 0
    scenes.each do |s|
      scene_hash = {}
      scene_jp = translateSceneToJP(s.text)

      if scene_jp == ""
        next
      end

      scene_hash["sceneJP"] = scene_jp
      scene_hash["sceneEN"] = s.text

      @scenes << scene_hash
    end

    #ハッシュタグリストを作成
    tagcounts = Tagcount.where('count > ?',10).order("count DESC").limit(tag_max_number)

    tags_include_not_jp = searchTableOr(Tag,"text",tagcounts)

    tags_include_not_jp.each do |t|
      if t.text == "이와테"
        next
      end
      if t.text.ascii_only? == false
        @tags << t
      end
    end

    selected_tag_number = 0

    picture_max_count = 15
    picture_count = 1

    if params[:tag_name] == nil and params[:scene_name] == nil and params[:search] == nil
      @selected_tab = 0
      if params[:album_title] != nil
        @selected_word = params[:album_title]
      end
      near_albums = calcNearAlbumsFromCurrentPosition(@current_lat,@current_lon,near_threshold)
      near_albums.each do |album|
        Picture.where(album_id:album.album_id).each do |picture|
        @pictures << picture
        picture_count = picture_count + 1
        if picture_count == picture_max_count
          break
        end
        end
      end
    elsif params[:search] != nil
      @searched_keyword = params[:search][:keyword]
      @pictures = Picture.where("title LIKE ?", "%#{escape_like(params[:search][:keyword])}%").limit(picture_max_count)
    elsif params[:scene_name] != nil
      @selected_tab = 2
      @selected_word = translateSceneToJP(params[:scene_name])
      scenes = Scene.where('text == ?',params[:scene_name])
      scenes.each do |scene|
        @pictures << Picture.where(id:scene.picture_id).first
        picture_count = picture_count + 1
        if picture_count == picture_max_count
          break
        end
      end
    else
      @selected_tab = 1
      @selected_word = params[:tag_name]
      tags = Tag.where('text == ?',params[:tag_name])
      tags.each do |tag|
        @pictures << Picture.where(id:tag.picture_id).first
        picture_count = picture_count + 1
        if picture_count == picture_max_count
          break
        end
      end
    end
  end

  #calcurate near albums from current position
  #param1 user's current lat
  #oaram2 user's current lon
  #param3 threshold of near
  #return near album array
  def calcNearAlbumsFromCurrentPosition(current_lat,current_lon,threshold_distance)
    near_albums = []
    min_near_album = nil
    min_distance = Float::MAX
    albums = Album.all

    albums.each do |album|
      album_lat = album.latitude
      album_lon = album.longitude

      distance = calcDistance(current_lat,current_lon,album_lat,album_lon)
      if distance < min_distance
        min_near_album = album
        min_distance = distance
      end
    end

    albums.each do |album|
      album_lat = album.latitude
      album_lon = album.longitude

      distance = calcDistance(min_near_album.latitude,min_near_album.longitude,album_lat,album_lon)
      if distance <= threshold_distance
        near_albums << album
      end
    end
    return near_albums
  end

  #calcurate 2 points distance
  #return distance[m]
  def calcDistance(lat1,lon1,lat2,lon2)
    a_lat = lat1.to_f * Math::PI / 180
    a_lon = lon1.to_f * Math::PI / 180
    b_lat = lat2.to_f * Math::PI / 180
    b_lon = lon2.to_f * Math::PI / 180

    latave = (a_lat + b_lat) / 2
    latidiff = a_lat - b_lat
    longdiff = a_lon - b_lon

    meridian = 6335439 / Math.sqrt((1 - 0.006694 * Math.sin(latave) * Math.sin(latave)) ** 3)

    primevertical = 6378137 / Math.sqrt(1 - 0.006694 * Math.sin(latave) * Math.sin(latave))

    x = meridian * latidiff
    y = primevertical * Math.cos(latave) * longdiff

    return Math.sqrt(x ** 2 + y ** 2)
  end

  def escape_like(string)
    return string.gsub(/[\\%_]/){|m| "\\#{m}"}
  end

  #creating sql of or
  def searchTableOr(table,keyword,words)
    table_define = table.arel_table

    sql = ""

    words.each do | word |
      if sql == ""
        sql = table_define[keyword].eq(word.text)
      else
        sql = sql.or(table_define[keyword].eq(word.text))
      end
    end

    result = table.where(sql).select(keyword).uniq!
    result.each do |r|
      puts r.text
    end
    return result
  end
end
