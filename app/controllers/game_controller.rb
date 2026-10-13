class GameController < ApplicationController
  def index
    @game = Game.new
  end
end
