class AddDataTakenToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :date, :string
  end
end
