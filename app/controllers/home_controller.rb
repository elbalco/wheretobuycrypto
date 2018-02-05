class HomeController < ApplicationController
  def index
    @events = Event.limit(10)
    @exchanges = Exchange.volume_not_nil.ordered.limit(10)
  end
end
