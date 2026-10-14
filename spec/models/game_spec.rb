require "rails_helper"

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { should have_one(:player_hand) }

    it { should have_one(:dealer_hand) }

    # it { should have_many(:cards).through(:player_hand) }
  end

  describe "setup_game" do
    it "should run on initialize" do
      game = Game.new
      expect(game.player_hand).not_to be nil
      expect(game.player_hand.cards).not_to be nil
    end

    it "should have one player hand" do
      game = Game.new
      expect(game.player_hand.role).to eq("player")
    end

    it "should have one dealer hand" do
      game = Game.new
      expect(game.dealer_hand.role).to eq('dealer')
    end

    it "should add 2 cards to game.player_hand" do
      game = Game.new
      expect(game.player_hand.cards.length).to be 2
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
