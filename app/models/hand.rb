class Hand < ApplicationRecord
  belongs_to :game
  has_many :cards, autosave: true

  def calculated_score(face_up_only: false)
    playable_cards = face_up_only ? self.cards.where(facedown: false) : self.cards

    # Removing 10 points at a time, ie change the value of one ace from 11 to 1
    # Only converting aces until the point total is <= 21
    score = playable_cards.sum(&:value)
    number_of_aces = playable_cards.where(rank: "Ace").count
    adjusted_score = score

    for i in 1..number_of_aces
      if adjusted_score <= 21
        break
      end
      adjusted_score = adjusted_score - 10
    end

    return adjusted_score if number_of_aces > 0 && score > 21

    score
  end
end
