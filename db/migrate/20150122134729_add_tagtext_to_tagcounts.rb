class AddTagtextToTagcounts < ActiveRecord::Migration
  def change
    add_column :tagcounts, :text, :string
  end
end
