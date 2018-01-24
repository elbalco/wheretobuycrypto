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
      "Easiest tool to find which exchange you can buy any cryptocurrency. We have 1500+ cryptocurrencies listed. Only trusted trusted exchanges updated in real-time"
    end
  end
end
