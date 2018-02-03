class FetchEvents
  def initialize
    @client = Coinmarketcal.new
    @exchange_regex = begin
      names = Exchange.pluck(:name).map{ |e| "(#{e})" }.join('|')
      /#{names}/i
    end
  end

  def call
      Event.destroy_all

      page = 1
      while events = @client.events(page: page, categories: "Exchange")
        save_events(events)
        page += 1
      end
  end

  private

  def save_events(events)
    events.each do |event|
      text = "#{event['title']} + #{event['description']}"
      if /list/i.match(text)
        if exchange_names = text.scan(@exchange_regex).flatten.compact.uniq
          coin = Coin.where('lower(name) = ?', event["coin_name"].downcase).first

          exchange_names.each do |exchange_name|
            exchange = Exchange.where('lower(name) = ?', exchange_name.downcase).first
            if coin && exchange
              unless CoinExchange.find_by(exchange: exchange, coin: coin)
                Event.create(
                  exchange: exchange,
                  coin: coin,
                  will_happen_at: event["date_event"].to_datetime,
                  data: event
                )
              end
            end
          end
        end
      end
    end
  end
end
