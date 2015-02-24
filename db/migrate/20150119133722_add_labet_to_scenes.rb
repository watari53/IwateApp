class AddLabetToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :score, :float
  end
end
