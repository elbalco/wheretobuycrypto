class UpdateAllCoinsWorker
  include Sidekiq::Worker

  def perform
    UpdateAllCoinsData.new.call
  end
end
