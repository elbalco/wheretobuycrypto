class CreateAllCoinsWorker
  include Sidekiq::Worker

  def perform
    CreateAllCoins.new.call
  end
end
