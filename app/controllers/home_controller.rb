class HomeController < ApplicationController
  def index
    @coins = Coin.ordered.limit(10)
    @exchanges = Exchange.volume_not_nil.ordered.limit(10)
  end
end
