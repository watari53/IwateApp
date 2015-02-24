class AddDetailToTags < ActiveRecord::Migration
  def change
    add_column :tags, :picture_id, :int
    add_column :tags, :text, :string
  end
end
