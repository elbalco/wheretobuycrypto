class Exchange < ActiveRecord::Base
  has_many :coin_exchanges
  has_many :coins, through: :coin_exchanges
end
