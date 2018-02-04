class CoinSerializer < BaseCoinSerializer
  has_many :exchanges
  has_many :events

  def exchanges
    object.coin_exchanges.sort_by(&:volume).reverse!
  end
end
