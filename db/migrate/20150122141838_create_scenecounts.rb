class CreateScenecounts < ActiveRecord::Migration
  def change
    create_table :scenecounts do |t|
      t.string :text
      t.integer :count

      t.timestamps
    end
  end
end
