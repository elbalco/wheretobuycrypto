class CoinSerializer < BaseCoinSerializer
  has_many :exchanges

  def exchanges
    object.coin_exchanges.sort_by(&:volume).reverse!
  end
end
