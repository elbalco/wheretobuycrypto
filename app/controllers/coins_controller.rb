class CoinsController < ApplicationController

  def index
    respond_to do |format|
      format.html {
        @coins = Coin.ordered.paginate(page: params[:page], per_page: 50)
      }
      format.json {
        if search = params[:search]
          coins = Coin.search(params[:search])
        else
          coins = Coin.all
        end
        render json: coins, each_serializer: BaseCoinSerializer
      }
    end
  end

  def show
    @coin = Coin.find_by(key: params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @coin }
    end
  end

end
