require "rails_helper"

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { should have_one(:player_hand) }

    it { should have_one(:dealer_hand) }
  end

  describe "setup_game" do
    it "should run on initialize" do
      game = build(:game)
      expect(game.player_hand).not_to be nil
      expect(game.player_hand.cards).not_to be nil
    end

    it "should have one player hand" do
      game = build(:game)
      expect(game.player_hand.role).to eq("player")
    end

    it "should have one dealer hand" do
      game = build(:game)
      expect(game.dealer_hand.role).to eq('dealer')
    end

    it "should add 2 cards to game.player_hand" do
      game = build(:game)
      expect(game.player_hand.cards.length).to be 2
    end

    context "when the game starts and the player has blackjack" do
      it "should check if player has blackjack" do
        # SETUP
        card_1 = create(:card, rank: 'Ace', value: 11, hand: create(:hand, game: create(:game)))
        card_2 = create(:card, rank: 'king', value: 10, hand: create(:hand, game: create(:game)))

        card_3 = create(:card, rank: '2', value: 2, hand: create(:hand, game: create(:game)))
        card_4 = create(:card, rank: '2', value: 2, hand: create(:hand, game: create(:game)))

        allow(Card).to receive_message_chain(:generate_deck, :shuffle).and_return([ card_1, card_2, card_3, card_4 ])

        game = create(:game)

        expect(game.player_hand.calculated_score).to be 21

        expect(game.winner).to eq('player')
      end
    end
  end

  describe "deck" do
      it "should be created on initialize" do
        game = build(:game)
        expect(game.deck).not_to be nil
        expect(game.deck.count).to be 48 # Four cards have been dealt, 52 - 4 = 48
      end

      it "should have 48 cards, in initial state of game" do
        game = build(:game)
        expect(game.deck).not_to be nil
        expect(game.deck.length).to be 48
      end
  end

  describe "player_hit" do
    it "Should add a card to the player hand" do
      game = create(:game)
      expect(game.player_hand.cards.count).to eq(2)

      game.player_hit

      expect(game.player_hand.cards.count).to eq(3)
    end

    it "Should check if the player busted" do
      game = create(:game)

      expect(game.winner).to eq(nil)

      game.dealer_hand.cards.destroy_all

      while game.player_hand.calculated_score <= 21
        game.player_hit
      end

      expect(game.winner).to eq('dealer')
    end

    it "Should check if the player won, if player gets 21" do
      game = create(:game)

      card_1 = create(:card, rank: 10, value: 10, hand: game.player_hand)
      card_2 = create(:card, rank: 9, value: 9, hand: game.player_hand)
      card_3 = create(:card, rank: 2, value: 2, hand: game.player_hand)

      game.player_hand.cards.destroy_all

      game.player_hand.cards << card_1
      game.player_hand.cards << card_2

      allow(game).to receive(:deck).and_return([ card_3 ])

      # ACTION
      game.player_hit

      expect(game.winner).to eq('player')
    end

    it "Should check if there was a tie" do
            game = create(:game)

      card_1 = create(:card, rank: 10, value: 10, hand: game.player_hand)
      card_2 = create(:card, rank: 9, value: 9, hand: game.player_hand)
      card_3 = create(:card, rank: 2, value: 2, hand: game.player_hand)

      game.player_hand.cards.destroy_all

      game.player_hand.cards << card_1
      game.player_hand.cards << card_2

      allow(game).to receive(:deck).and_return([ card_3 ])


      card_4 = create(:card, rank: 'Ace', value: 11, hand: game.dealer_hand)
      card_5 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)

      game.dealer_hand.cards.destroy_all

      game.dealer_hand.cards << card_4
      game.dealer_hand.cards << card_5

      # ACTION
      game.player_hit

      expect(game.winner).to eq('tie')
    end
  end

  describe "player_stay" do
    it "Should flip the dealer's facedown card" do
      game = create(:game)
      expect(game.dealer_hand.cards.where(facedown: true).any?).to eql(true)

      game.player_stay
      expect(game.dealer_hand.cards.where(facedown: true).any?).to eql(false)
    end

    it "Should deal the dealer cards until they have at least 17" do
      # SETUP
      game = create(:game)
      game.dealer_hand.cards.destroy_all

      card_1 = create(:card, rank: 2, value: 2, hand_id: game.player_hand.id)
      card_2 = create(:card, rank: 2, value: 2, hand_id: game.player_hand.id)
      custom_cards = [ card_1, card_2 ]

      game.dealer_hand.cards = custom_cards

      expect(game.dealer_hand.calculated_score).to be 4 # < 17

      # ACTION
      game.player_stay

      expect(game.dealer_hand.calculated_score).to be >= 17
    end

    it "Should check for a tie" do
      # SETUP
      game = create(:game)
      game.player_hand.cards.destroy_all

      card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
      card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)

      game.player_hand.cards = [ card_1, card_2 ]

      expect(game.player_hand.calculated_score).to be 21

      card_4 = create(:card, rank: 'Ace', value: 11, hand: game.dealer_hand)
      card_5 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)

      game.dealer_hand.cards.destroy_all

      game.dealer_hand.cards = [ card_4, card_5 ]

      # ACTION
      game.player_stay

      expect(game.winner).to eq('tie')
    end

    context 'when checking for a winner' do
      it "Should check for dealer bust" do
        # SETUP
        game = create(:game)
        game.player_hand.cards.destroy_all

        card_1 = create(:card, rank: 'Ace', value: 11, hand_id: game.player_hand.id)
        card_2 = create(:card, rank: '10', value: 10, hand_id: game.player_hand.id)

        game.player_hand.cards = [ card_1, card_2 ]

        expect(game.player_hand.calculated_score).to be 21

        card_4 = create(:card, rank: 'Ace', value: 11, hand: game.dealer_hand)
        card_5 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)
        card_6 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)
        card_7 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)

        game.dealer_hand.cards.destroy_all

        game.dealer_hand.cards = [ card_4, card_5, card_6, card_7 ]

        # ACTION
        game.player_stay

        expect(game.winner).to eq('player')
      end

      it "Should check if the player won, if player gets more points then the dealer" do
        game = create(:game)

        card_1 = create(:card, rank: 10, value: 10, hand: game.player_hand)
        card_2 = create(:card, rank: 8, value: 8, hand: game.player_hand)
        card_3 = create(:card, rank: 2, value: 2, hand: game.player_hand)

        game.player_hand.cards.destroy_all

        game.player_hand.cards << card_1
        game.player_hand.cards << card_2
        game.player_hand.cards << card_3

        card_4 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)
        card_5 = create(:card, rank: '4', value: 4, hand: game.dealer_hand)
        card_6 = create(:card, rank: '3', value: 3, hand: game.dealer_hand)

        game.dealer_hand.cards.destroy_all

        game.dealer_hand.cards << card_4
        game.dealer_hand.cards << card_5

        # Deck is where the next card is pulled from on player hit
        allow(game).to receive(:deck).and_return([ card_6 ])

        # ACTION
        game.player_stay

        expect(game.winner).to eq('player')
      end

      it "Should check if the dealer won, if dealer gets more points then the player" do
        game = create(:game)

        card_1 = create(:card, rank: 10, value: 10, hand: game.player_hand)
        card_2 = create(:card, rank: 4, value: 4, hand: game.player_hand)
        card_3 = create(:card, rank: 3, value: 2, hand: game.player_hand)

        game.player_hand.cards.destroy_all

        game.player_hand.cards << card_1
        game.player_hand.cards << card_2
        game.player_hand.cards << card_3

        card_4 = create(:card, rank: '10', value: 10, hand: game.dealer_hand)
        card_5 = create(:card, rank: '8', value: 8, hand: game.dealer_hand)
        card_6 = create(:card, rank: '2', value: 2, hand: game.dealer_hand)

        game.dealer_hand.cards.destroy_all

        game.dealer_hand.cards << card_4
        game.dealer_hand.cards << card_5

        # Deck is where the next card is pulled from on player hit
        allow(game).to receive(:deck).and_return([ card_6 ])

        # ACTION
        game.player_stay

        expect(game.winner).to eq('dealer')
      end
    end
  end
end
