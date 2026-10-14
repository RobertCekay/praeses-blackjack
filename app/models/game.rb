class Game < ApplicationRecord
  has_one :player_hand, -> { where(role: "player") }, class_name: "Hand"
  has_one :dealer_hand, -> { where(role: "dealer") }, class_name: "Hand"
  # has_many :cards, through: :hand

  after_initialize :setup_game

  def setup_game
    self.player_hand = Hand.new(role: "player")
    self.player_hand.cards << deck.sample
    self.player_hand.cards << deck.sample

    self.dealer_hand = Hand.new(role: "dealer")
    self.dealer_hand.cards << deck.sample

    facedown_card = deck.sample
    facedown_card.facedown = true
    self.dealer_hand.cards << facedown_card

    save!
  end

  def deck
    @deck ||= Card.generate_deck
  end

  def dealer_score
    dealer_hand.cards.where(facedown: nil).sum(&:value)
  end
end
