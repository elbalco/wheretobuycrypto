class PublishTweet
  include Sidekiq::Worker

  def perform(text)
    TwitterClient.client.update(text)
  end
end
