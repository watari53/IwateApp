class AddRepresentativepictureToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :representative_picture, :int
  end
end
