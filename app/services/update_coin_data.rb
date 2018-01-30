class UpdateCoinData
  CMC_EXCHANGE_REGEX = /\/exchanges\/([^\/]*)/

  def initialize(coin)
    @coin = coin
  end

  def call
    pair_regex = /#{@coin.symbol}\/(.*)/

    doc = Nokogiri::HTML(open("https://coinmarketcap.com/currencies/#{@coin.key}/#markets"))
    rows = doc.css('tr')
    rows.shift
    rows.each do |row|
      row_data = Nokogiri::HTML(row.to_s).css('td')
      if row_data.count > 1
        exchange_name     = row_data[1].text
        market_pair_coin  = row_data[2].text
        cmc_exchange_url  = "https://coinmarketcap.com/#{row_data.xpath('//a/@href')[0].value}"
        market_url        = row_data.xpath('//a/@href')[1].value
        key               = cmc_exchange_url.scan(CMC_EXCHANGE_REGEX).flatten.first
        pair_coin_symbol  = row_data[2].text.gsub(@coin.symbol, "").gsub("/", "")
        pair_coin         = Coin.find_by(symbol: pair_coin_symbol)
        volume            = row_data[3].text.gsub(/[\s$,]+/, "").to_i

        unless pair_coin.blank?
          exchange = Exchange.find_or_create_by(key: key, name: exchange_name)
          coin_exchange = CoinExchange.find_or_initialize_by(coin_id: @coin.id, exchange_id: exchange.id)
          if coin_exchange.new_record?
            coin_exchange.save
            if @coin.created_at >= 1.day.ago
              perform_at = (rand * 120).round.minutes.from_now
              tweet_text = "#{@coin.name} $#{@coin.symbol} was just listed on ##{exchange.key}!🚀\n\n" +
                           "Find where you can buy #{@coin.symbol} here: #{coin_url(@coin)}"
              PublishTweet.perform_at(perform_at, tweet_text)
            end
          end
          market = Market.find_or_create_by(coin_exchange_id: coin_exchange.id, coin_id: pair_coin.id)
          market.update_attributes(url: market_url, volume_24h: volume)
        end
      end
    end
  end
end
