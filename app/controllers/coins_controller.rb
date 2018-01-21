class CoinsController < ApplicationController
  def index
    if search = params[:search]
      coins = Coin.search(params[:search])
    else
      coins = Coin.all
    end
    render json: coins, each_serializer: BaseCoinSerializer
  end

  def show
    @coin = Coin.find_by(key: params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @coin }
    end
  end
end
