class AddFieldsToExchange < ActiveRecord::Migration[5.0]
  def change
    add_column :exchanges, :volume_24h, :integer, limit: 8
    add_column :exchanges, :referral_url, :string
  end
end
