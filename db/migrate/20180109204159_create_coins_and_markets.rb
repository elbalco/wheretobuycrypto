class CreateCoinsAndMarkets < ActiveRecord::Migration[5.0]
  def change
    create_table :coins do |t|
      t.string :key, index: true
      t.string :name
      t.string :symbol
      t.timestamps
    end

    create_table :exchanges do |t|
      t.string :key, index: true
      t.string :name
      t.string :url
      t.timestamps
    end

    create_table :coin_exchanges do |t|
      t.belongs_to :coin, index: true
      t.belongs_to :exchange, index: true
      t.string :url
      t.integer :volume_24h
    end

    create_table :markets do |t|
      t.belongs_to :coin_exchange
      t.belongs_to :coin
      t.string :url
      t.integer :volume_24h
    end
  end
end
