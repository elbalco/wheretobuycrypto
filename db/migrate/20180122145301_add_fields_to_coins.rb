class AddFieldsToCoins < ActiveRecord::Migration[5.0]
  def change
    add_column :coins, :volume_24h, :integer, limit: 8
    add_column :coins, :market_cap, :integer, limit: 8
    add_column :coins, :rank, :integer
    add_column :coins, :price, :decimal
  end
end
