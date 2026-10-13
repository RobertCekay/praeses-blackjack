class Hand < ApplicationRecord
  belongs_to :game
  has_many :cards, autosave: true

  def summed_score
    self.cards.sum(&:value)

    # self.cards.first.value
  end
end
