class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.integer :picture_id
      t.string :text
      t.timestamps
    end
  end
end
