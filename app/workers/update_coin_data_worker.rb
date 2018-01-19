class UpdateCoinDataWorker
  include Sidekiq::Worker

  def perform(coin_id)
    coin = Coin.find(coin_id)
    UpdateCoinData.new(coin).call
  end
end
