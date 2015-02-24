class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :area
      t.string :ja
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
