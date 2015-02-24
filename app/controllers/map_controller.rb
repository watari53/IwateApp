class MapController < ApplicationController
  def index
    @areas = Area.all
    gon.areas = @areas
    @hash = Gmaps4rails.build_markers(@areas) do |area, marker|
      marker.lat area.latitude
      marker.lng area.longitude
#      marker.infowindow album.description
      marker.json({title: area.area})
    end
  end

  def lists
    @selected_area = params[:area]
    @lat = params[:lat]
    @lng = params[:lng]
    @albums = Album.where(area: @selected_area)

    @albums_with_distance = []

    @albums.each do |album|
      y1 = @lat.to_f * Math::PI / 180
      x1 = @lng.to_f * Math::PI / 180
      y2 = album.latitude * Math::PI / 180
      x2 = album.longitude * Math::PI / 180
      earth_r = 6378140

      deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
      distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000

      album_with_distance = {}
      album_with_distance["id"] = album.id
      album_with_distance["title"] = album.title
      album_with_distance["address"] = album.address
      album_with_distance["latitude"] = album.latitude
      album_with_distance["longitude"] = album.longitude
      album_with_distance["representative_picture"] = "nothing"
      if  Picture.where(album_id:album.album_id).first != nil
        album_with_distance["representative_picture"] = Picture.where(album_id:album.album_id).first.url
      end
      album_with_distance["album_id"] = album.album_id
      album_with_distance["area"] = album.area
      album_with_distance["distance"] = distance.round(2)

      @albums_with_distance << album_with_distance
    end
  end

  def route
    @lat = params[:lat]
    @lng = params[:lng]
    @destination_lat = params[:dstlat]
    @destination_lng = params[:dstlng]
  end
end
