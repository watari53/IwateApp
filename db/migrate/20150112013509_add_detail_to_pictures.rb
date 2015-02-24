class AddDetailToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :url, :string
    add_column :pictures, :latitude, :float
    add_column :pictures, :longitude, :float
    add_column :pictures, :address, :string
    add_column :pictures, :title, :string
    add_column :pictures, :album_id, :int
  end
end
