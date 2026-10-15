require "rails_helper"

RSpec.describe Card, type: :model do
  describe 'associations' do
    it { should belong_to(:hand) }
  end
  describe "color" do
    it "Should return red for hearts" do
      card = create(:card,
                      hand: create(:hand, game: create(:game)),
                      suit: 'hearts')

      expect(card.color).to eq('red')
    end

        it "Should return red for diamonds" do
      card = create(:card,
                      hand: create(:hand, game: create(:game)),
                      suit: 'diamonds')

      expect(card.color).to eq('red')
    end

        it "Should return black for clubs" do
      card = create(:card,
                      hand: create(:hand, game: create(:game)),
                      suit: 'clubs')

      expect(card.color).to eq('black')
    end

        it "Should return black for spades" do
      card = create(:card,
                      hand: create(:hand, game: create(:game)),
                      suit: 'spades')

      expect(card.color).to eq('black')
    end
  end

  describe "generate_deck" do
    it "should create 1 card for each rank, once for each suit" do
      deck = Card.generate_deck

      hearts = deck.select { |c| c.suit == 'hearts' }
      expect(hearts.count).to eq(13)

      spades = deck.select { |c| c.suit == 'spades' }
      expect(spades.count).to eq(13)

      clubs = deck.select { |c| c.suit == 'clubs' }
      expect(clubs.count).to eq(13)

      diamonds = deck.select { |c| c.suit == 'diamonds' }
      expect(diamonds.count).to eq(13)

      Card::RANKS.each do |rank|
        in_hearts = hearts.select { |c| c.rank == rank }.any?
        in_spades = hearts.select { |c| c.rank == rank }.any?
        in_clubs = hearts.select { |c| c.rank == rank }.any?
        in_diamonds = hearts.select { |c| c.rank == rank }.any?

        expect(in_hearts).to eq(true)
        expect(in_spades).to eq(true)
        expect(in_clubs).to eq(true)
        expect(in_diamonds).to eq(true)
      end
    end
  end

  describe "to_s" do
    it "should result in" do
      card = create(:card,
                      hand: create(:hand, game: create(:game)),
                      rank: 'Ace', suit: 'spades')

      expect(card.to_s).to eq('Ace of spades') # ;)
    end
  end
end
