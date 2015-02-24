class RemovePictureFromPictures < ActiveRecord::Migration
  def change
    remove_column :pictures, :picture, :string
  end
end
