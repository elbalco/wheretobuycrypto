class CreateCoinsAndMarkets < ActiveRecord::Migration[5.0]
  def change
    create_table :coins do |t|
      t.string :key
      t.string :name
      t.string :symbol
      t.timestamps
    end

    create_table :markets do |t|
      t.string :key
      t.string :name
      t.string :url
      t.timestamps
    end

    create_table :coins_markets do |t|
      t.belongs_to :coin, index: true
      t.belongs_to :market, index: true
    end
  end
end
