class CoinExchange < ActiveRecord::Base
  belongs_to :coin
  belongs_to :exchange
  has_many :markets

  def volume
    markets.sum(:volume_24h)
  end
end
