class AddDetailsToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :description, :string
    add_column :albums, :detail, :string
  end
end
