require "rails_helper"

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { should have_one(:hand) }

    it { should have_many(:cards).through(:hand) }
  end

  describe "setup_game" do
    it "should run on initialize" do
      game = Game.new
      expect(game.hand).not_to be nil
      expect(game.hand.cards).not_to be nil
    end

    it "should add 2 cards to game.hand" do
      game = Game.new
      expect(game.hand.cards.length).to be 2
    end
  end

  describe "deck" do
      it "should be created on initialize" do
        game = Game.new
        expect(game.deck).not_to be nil
        expect(game.deck.length).to be 52
      end

      it "should have 52 cards" do
        game = Game.new
        expect(game.deck).not_to be nil
        expect(game.deck.length).to be 52
      end
  end
end
