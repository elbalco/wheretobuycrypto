module ApplicationHelper
  def coin_to_json(coin)
    serializer = CoinSerializer.new(coin)
    adapter = ActiveModel::Serializer::Adapter.create(serializer)
    adapter.as_json
  end

  def get_description
    if @coin
      "Find all exchanges where #{@coin.name}(#{@coin.symbol}) cryptocurrency can be bought or exchanged. Easiest tool to find which exchange you can buy any cryptocurrency."
    else
      "Easiest tool to find which exchange you can buy any cryptocurrency. We have 1500+ cryptocurrencies listed. List of trusted exchanges where you can buy Bitcoin, Ethereum, Ripple, Bitcoin Cash, Cardano, Litecoin, NEM, NEO, Stellar, IOTA, Icon, Wanchain, ...and 1500 more."
    end
  end
end
