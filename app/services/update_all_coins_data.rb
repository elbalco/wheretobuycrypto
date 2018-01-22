class UpdateAllCoinsData
  def call
    Coinmarketcap.coins(limit = 10000).each do |coin_data|
      coin = Coin.find_or_create_by(key: coin_data["id"])
      coin.update_attributes({
        name: coin_data["name"],
        symbol: coin_data["symbol"],
        market_cap: coin_data["market_cap_usd"],
        volume_24h: coin_data["24h_volume_usd"],
        rank: coin_data["rank"],
        price: coin_data["price_usd"]
      })
      UpdateCoinDataWorker.perform_async(coin.id)
    end
  end
end
