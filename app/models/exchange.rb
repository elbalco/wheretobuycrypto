class Exchange < ActiveRecord::Base
  has_many :coin_exchanges
  has_many :coins, through: :coin_exchanges

  scope :volume_not_nil, -> { where("exchanges.volume_24h IS NOT NULL") }
  scope :ordered, -> { order("volume_24h desc") }

  def url
    referral_url || super
  end
end
