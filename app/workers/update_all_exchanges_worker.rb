class UpdateAllExchangesWorker
  include Sidekiq::Worker

  def perform
    UpdateAllExchanges.new.call
  end
end
