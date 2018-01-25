class TweetGainersWorker
  include Sidekiq::Worker

  def perform
    TweetGainers.new.call
  end
end
