class GameController < ApplicationController
  def index
    @game = Game.new
    @game.hand = Hand.new
  end
end
