class CoinSerializer < ActiveModel::Serializer
  attributes :id, :key, :name, :symbol
  has_many :exchanges

  def exchanges
    object.coin_exchanges.sort_by(&:volume).reverse!
  end
end
