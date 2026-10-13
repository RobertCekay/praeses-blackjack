class Game < ApplicationRecord
  has_one :hand, autosave: true
  has_many :cards

  after_initialize :setup_game

  def setup_game
    self.hand = Hand.new
    self.hand.cards << deck.pop
    self.hand.cards << deck.pop
  end

  def deck
    @deck ||= Card.generate_deck
  end
end
