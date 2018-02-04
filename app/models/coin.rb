class Coin < ActiveRecord::Base
  has_many :coin_exchanges
  has_many :exchanges, through: :coin_exchanges
  has_many :events

  scope :ordered, -> { order(:rank) }

  def self.search(param)
    Coin.where("key ILIKE ? OR name ILIKE ? OR symbol ILIKE ?", "%#{param}%","%#{param}%","%#{param}%")
  end

  def to_param
    key
  end
end
