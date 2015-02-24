class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.string :description
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :date

      t.timestamps
    end
  end
end
