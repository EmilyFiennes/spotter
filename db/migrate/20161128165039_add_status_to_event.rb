class AddStatusToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :available, :boolean, default: true
  end
end
