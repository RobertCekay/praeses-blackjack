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

    context 'when the player has an ace, summed_score' do
      it 'should have a value of 11, if that is better for the player' do
        # SETUP
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)

        game.player_hand.cards = [ card_1, card_2 ]

        expect(game.player_hand.summed_score).to be 21

        card_4 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)
        card_5 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)

        game.dealer_hand.cards.destroy_all

        game.dealer_hand.cards = [ card_4, card_5 ]

        # ACTION
        game.player_stay

        expect(game.winner).to eq('player')
      end

      it 'should have a value of 1 1 for aces, if that is better for the player' do
        # SETUP
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)
        card_3 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)

        game.player_hand.cards = [ card_1, card_2, card_3 ]

        expect(game.player_hand.summed_score).to be 21

        card_4 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)
        card_5 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)

        game.dealer_hand.cards.destroy_all

        game.dealer_hand.cards = [ card_4, card_5 ]

        # ACTION
        game.player_stay

        expect(game.winner).to eq('player')
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

        expect(game.player_hand.summed_score).to be 21

        card_6 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)
        card_7 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)

        game.dealer_hand.cards.destroy_all

        game.dealer_hand.cards = [ card_6, card_7 ]

        # ACTION
        game.player_stay

        expect(game.winner).to eq('player')
      end
    end
  end
end
