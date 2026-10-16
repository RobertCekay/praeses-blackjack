class Hand < ApplicationRecord
  belongs_to :game
  has_many :cards, autosave: true

  def summed_score
    score = self.cards.sum(&:value)
    hand_has_ace = self.cards.where(rank: "Ace").any?
    number_of_aces = self.cards.where(rank: "Ace").count
    adjusted_score = score - (10 * number_of_aces)

    return adjusted_score if hand_has_ace && score > 21

    score
  end
end
