class Coin < ActiveRecord::Base
  has_many :coin_exchanges
  has_many :exchanges, through: :coin_exchanges
end
