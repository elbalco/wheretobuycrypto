class CreateAllCoins
  def call
    Coinmarketcap.coins(limit = 10000).each do |coin_data|
      coin = Coin.find_or_initialize_by(key: coin_data["id"], name: coin_data["name"], symbol: coin_data["symbol"])
      if coin.new_record?
        coin.save
        perform_at = (rand * 120).round.minutes.from_now
        PublishTweet.perform_at(perform_at, "#{coin.name} $#{coin.symbol} was just added to our exchange search tool! 🎉🎊\n\nFind where to buy it here: #{coin_url(coin)}")
      end
    end
  end
end
