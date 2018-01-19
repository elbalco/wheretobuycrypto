require 'open-uri'

class ImportCoinPictures
  CRYPTOCOMPARE_HOST = "https://www.cryptocompare.com"

  def call
    coin_data = Cryptocompare::CoinList.all["Data"]

    coin_data.each do |key, data|
      if coin = Coin.find_by(symbol: key)
        if image_path = data["ImageUrl"]
          image_url = "#{CRYPTOCOMPARE_HOST}#{image_path}"
          extension = image_url.split('.').last
          open(image_url) do |f|
             File.open("#{Rails.root}/app/assets/images/coins/#{coin.key}.#{extension}","wb") do |file|
               file.puts f.read
             end
          end
        end
      end
    end
  end
end
