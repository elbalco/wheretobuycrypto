class UpdateAllExchanges
  def call
    Exchange.all.each do |exchange|
      UpdateExchangeDataWorker.perform_async(exchange.id)
    end
  end
end
