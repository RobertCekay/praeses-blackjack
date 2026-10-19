require "rails_helper"

RSpec.describe Hand, type: :model do
  describe 'associations' do
    it { should belong_to(:game) }

    it { should have_many(:cards) }
  end

  describe "calculated_score" do
    it "should return sum of all of a given hand's card values" do
      game = create(:game)

      expect(game.player_hand.calculated_score).to be game.player_hand.cards.sum(&:value)
    end

    it "should only consider face up cards when the face_up_only param is true" do
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)
        card_3 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)
        card_4 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id, facedown: true)

        game.player_hand.cards = [ card_1, card_2, card_3, card_4 ]

        expect(game.player_hand.calculated_score(face_up_only: true)).to be 21
    end

    context 'when the player has an ace, calculated_score' do
      it 'should have a value of 11, if that is better for the player' do
        # SETUP
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)

        game.player_hand.cards = [ card_1, card_2 ]

        expect(game.player_hand.calculated_score).to be 21
      end

      it 'should have a value of 1 for aces, if that is better for the player' do
        # SETUP
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)
        card_3 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)

        game.player_hand.cards = [ card_1, card_2, card_3 ]

        expect(game.player_hand.calculated_score).to be 21
      end

      it 'should have a value of 1 for aces, 3 aces, 2 9\'s' do
        # SETUP
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_3 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_4 = create(:card, rank: '9', value: 9, hand_id: game.player_hand.id)
        card_5 = create(:card, rank: '9', value: 9, hand_id: game.player_hand.id)

        game.player_hand.cards = [ card_1, card_2, card_3, card_4, card_5 ]

        expect(game.player_hand.calculated_score).to be 21
      end

      it "Should decrease the value of am Ace from 11 to 1 if it busts player" do
        game = create(:game)

        card_1 = create(:card, rank: 'Ace', value: 11, hand: game.player_hand)
        card_2 = create(:card, rank: 9, value: 9, hand: game.player_hand)
        card_3 = create(:card, rank: 4, value: 4, hand: game.player_hand)

        game.player_hand.cards.destroy_all

        game.player_hand.cards << card_1
        game.player_hand.cards << card_2
        game.player_hand.cards << card_3

        expect(game.player_hand.calculated_score).to eq(14)
      end

      context 'when multiple aces are in a player or dealer hand' do
        it "Should only decrease the value of aces until hand total is 21" do
          game = create(:game)

          card_1 = create(:card, rank: 'Ace', value: 11, hand: game.player_hand)
          card_2 = create(:card, rank: 'Ace', value: 11, hand: game.player_hand)
          card_3 = create(:card, rank: 4, value: 4, hand: game.player_hand)

          game.player_hand.cards.destroy_all

          game.player_hand.cards << card_1
          game.player_hand.cards << card_2
          game.player_hand.cards << card_3

          expect(game.player_hand.calculated_score).to eq(16)
        end
      end
    end
  end
end
