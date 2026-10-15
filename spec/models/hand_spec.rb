require "rails_helper"

RSpec.describe Hand, type: :model do
  describe 'associations' do
    it { should belong_to(:game) }

    it { should have_many(:cards) }
  end

  describe "summed_score" do
    it "should return sum of all of a given hand's card values" do
      game = create(:game)

      expect(game.player_hand.summed_score).to be game.player_hand.cards.sum(&:value)
    end
  end
end
