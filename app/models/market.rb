class Market < ActiveRecord::Base
  belongs_to :coin
  belongs_to :coin_exchange

  scope :ordered, -> { order("volume_24h desc") }
end
