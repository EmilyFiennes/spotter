class AddPictureStampToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :picture_stamp, :string
  end
end
