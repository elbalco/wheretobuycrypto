class Exchange < ActiveRecord::Base
  has_many :coin_exchanges
  has_many :coins, through: :coin_exchanges

  scope :ordered, -> { order("volume_24h desc") }

  def url
    referral_url || super
  end
end
