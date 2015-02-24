class RemoveCountFromTags < ActiveRecord::Migration
  def change
    remove_column :tags, :count, :integer
  end
end
