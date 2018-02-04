class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :coin_id
      t.integer :exchange_id
      t.datetime :will_happen_at
      t.text :data
      t.timestamps
    end
    add_index :events, :coin_id
    add_index :events, :exchange_id
  end
end
