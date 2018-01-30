class TweetGainers
  BITGUR_DAY_GAINERS_URL = "https://bitgur.com/aj/trending-table?source=gainers&limit=10&offset=0&priceChange=DAY"

  def call
    response = HTTParty.get(BITGUR_DAY_GAINERS_URL)
    coins = JSON.parse(response.body)
    if coins.respond_to?(:each)
      tweet = "Top #crypto gainers last 24h:\n\n"
      coins.first(5).each_with_index do |coin, index|
        tweet << case index
        when 0
          "🌕"
        when 1
          "🚀"
        else
          "⚡"
        end
        tweet << " #{coin["currency"]["name"]} $#{coin["currency"]["symbol"]} #{coin["priceChange"]}%\n"
      end
      tweet << "\nWHERE TO BUY THEM HERE: https://www.wheretobuycrypto.io \n\n"
      tweet << "#cryptocurrency #ToTheMoon #CryptoNews"
      PublishTweet.perform_async(tweet)
    end
  end
end
