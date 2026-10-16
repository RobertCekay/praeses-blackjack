class Hand < ApplicationRecord
  belongs_to :game
  has_many :cards, autosave: true

  def calculated_score(face_up_only: false)
    playable_cards = face_up_only ? self.cards.where(facedown: false) : self.cards

    score = playable_cards.sum(&:value)
    number_of_aces = playable_cards.where(rank: "Ace").count
    adjusted_score = score - (10 * number_of_aces)

    return adjusted_score if number_of_aces > 0 && score > 21

    score
  end
end
