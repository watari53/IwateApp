class CreateTagcounts < ActiveRecord::Migration
  def change
    create_table :tagcounts do |t|
      t.integer :tag_id
      t.string :count

      t.timestamps
    end
  end
end
