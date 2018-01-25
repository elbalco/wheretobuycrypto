class TweetCoinmarketCalEvents
  def initialize
    @client = TwitterClient.client
  end

  def call
     datestr = Date.today.strftime("%d/%m")
     if tweet = TwitterClient.client.search("from:coinmarketcal #{datestr}").first
       text = "16/01 most popular #cryptocurrency #events\n\n$GNT Blockchain Workshop\n$SYS Blockmarket 1.2\n$SUB SUBLOCC Event\n$RCN A… https://t.co/togMx5T0Y3", "15/01 #cryptocurrency #events\n\n$GUP $QGUP Airdrop\n$ADA Cardano Webcast\n$EBST Staking &amp; Reward\n$PAC PACfyle Alpha La… https://t.co/88mYubsxL7"
       new_tweet = "#{datestr} #cryptocurrency #events via @coinmarketcal\n\n"
       symbols = tweet[:entities][:symbols].map do |symbol|
         sym = symbol[:text]
         sym_regex = /#{sym}(.*)/
         sym_text = text.scan(sym_regex).flatten.first
         coin = Coin.find_by(symbol: sym)
         if coin.present? && sym_text.present?
           new_tweet = "🚀 ##{coin.name} #cryptocurrency #event is happening today! #{datestr}\n"+
                       "$#{sym} -> #{sym_text}\n"
                       "Find out where to buy #{sym} here: #{coin_url(coin)}"
           publish_at = (rand * 120).round.minutes.from_now
           PublishTweet.perform_at(publish_at, text)
         end
       end
     end
  end
end
