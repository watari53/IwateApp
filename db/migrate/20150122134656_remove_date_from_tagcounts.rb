class RemoveDateFromTagcounts < ActiveRecord::Migration
  def change
    remove_column :tagcounts, :tag_id, :integer
  end
end
