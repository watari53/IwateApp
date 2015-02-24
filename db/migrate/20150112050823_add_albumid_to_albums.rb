class AddAlbumidToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :album_id, :int
  end
end
