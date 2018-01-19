class UpdateExchangeDataWorker
  include Sidekiq::Worker

  def perform(exchange_id)
    exchange = Exchange.find(exchange_id)
    UpdateExchangeData.new(exchange).call
  end
end
