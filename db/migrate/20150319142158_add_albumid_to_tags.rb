class AddAlbumidToTags < ActiveRecord::Migration
  def change
    add_column :tags, :album_id, :integer
  end
end
