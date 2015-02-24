class RemoveDescriptionFromAlbums < ActiveRecord::Migration
  def change
    remove_column :albums, :description, :string
  end
end
