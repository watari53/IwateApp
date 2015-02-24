class AddAreaToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :area, :string
  end
end
