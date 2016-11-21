class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.string :address
      t.references :user, foreign_key: true
      t.text :description
      t.datetime :cancelled_at
      t.references :activity, foreign_key: true
      t.string :level

      t.timestamps
    end
  end
end
