class UpdateAllExchanges
  def call
    Exchange.all.each do |exchange|
      UpdateExchangeData.new(exchange).call
    end
  end
end
