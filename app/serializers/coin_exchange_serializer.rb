class CoinExchangeSerializer < ActiveModel::Serializer
  attributes :id, :key, :name, :url, :volume, :markets
  delegate :id, :key, :name, :url, to: :exchange

  def markets
    object.markets.order("volume_24h desc").map(&:coin).map(&:symbol)
  end

  def exchange
    object.exchange
  end
end
