class AddAlbumidToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :album_id, :integer
  end
end
