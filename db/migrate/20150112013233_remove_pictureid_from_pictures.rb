class RemovePictureidFromPictures < ActiveRecord::Migration
  def change
    remove_column :pictures, :picture_id, :int
  end
end
