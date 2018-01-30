class ExchangesController < ApplicationController

  def index
    respond_to do |format|
      format.html {
        @exchanges = Exchange.volume_not_nil.ordered.paginate(page: params[:page], per_page: 80)
      }
    end
  end

end
