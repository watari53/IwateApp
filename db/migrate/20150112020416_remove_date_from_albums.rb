class RemoveDateFromAlbums < ActiveRecord::Migration
  def change
    remove_column :albums, :date, :string
  end
end
