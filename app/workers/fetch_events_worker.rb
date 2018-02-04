class FetchEventsWorker
  include Sidekiq::Worker

  def perform
    FetchEvents.new.call
  end
end
