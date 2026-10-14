class GamesController < ApplicationController
  def index
    @game = Game.new
  end

  def play
    @game = Game.find(params[:id])

    if game_params[:hit] == "true"
      @game.player_hit
    elsif game_params[:stay] == "true"
      @game.player_stay
    end
  end

    private

  def game_params
    # Requires the :product key and only allows :name and :price
    params.permit(:hit, :stay)
  end
end
