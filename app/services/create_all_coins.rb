class CreateAllCoins
  def call
    Coinmarketcap.coins(limit = 10000).each do |coin_data|
      coin = Coin.find_or_create_by(key: coin_data["id"], name: coin_data["name"], symbol: coin_data["symbol"])
    end
  end
end
