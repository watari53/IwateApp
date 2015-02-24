class AddPlacekindToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :place_id, :integer
  end
end
