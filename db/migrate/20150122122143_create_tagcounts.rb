class CreateTagcounts < ActiveRecord::Migration
  def change
    create_table :tagcounts do |t|
      t.integer :tag_id
      t.integer :count

      t.timestamps
    end
  end
end
