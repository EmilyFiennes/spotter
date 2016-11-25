class AddMessengerIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :messenger_id, :string
  end
end
