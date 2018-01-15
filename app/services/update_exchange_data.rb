class UpdateExchangeData
  def initialize(exchange)
    @exchange = exchange
  end

  def call
    doc = Nokogiri::HTML(open("https://coinmarketcap.com/exchanges/#{@exchange.key}"))

    url = doc.css(".glyphicon-link").first.parent.css("a").xpath('@href').first.value
    volume_24h = doc.css("[data-currency-volume]").xpath("@data-usd").first.value
    name = doc.css("h1").first.text.strip

    @exchange.update_attributes({
      name: name,
      url: url,
      volume_24h: volume_24h
    })
  end
end
