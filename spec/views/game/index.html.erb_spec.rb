require "rails_helper"

RSpec.describe "game/index.html.erb", type: :view do
  before do
    # Assign instance variables that the view expects from the controller
    @game = Game.new
  end

  it "render page" do
    render
    expect(rendered).to match(/Blackjack/)
  end

  # Initial State of Game
  context 'Inital State' do
    it "Should show two player cards" do
      render

      expect(rendered).to have_css(".player-card", count: 2)

      card_1 = @game.player_hand.cards[0]
      card_1_text = card_1.rank + ' of ' + card_1.suit
      expect(rendered).to have_css(".player-card-info", text: card_1_text)

      card_2 = @game.player_hand.cards[1]
      card_2_text = card_2.rank + ' of ' + card_2.suit
      expect(rendered).to have_css(".player-card-info", text: card_2_text)
    end

    it "Should show two dealer cards, with one facedown" do
      render

      expect(rendered).to have_css(".dealer-card", count: 2)

      card_1 = @game.dealer_hand.cards[0]
      card_1_text = card_1.rank + ' of ' + card_1.suit
      expect(rendered).to have_css(".dealer-card-info", text: card_1_text)

      card_2 = @game.dealer_hand.cards[1]
      card_2_text = card_2.rank + ' of ' + card_2.suit
      expect(rendered).not_to have_css(".dealer-card-info", text: card_2_text)
    end
  end




  # My Turn
  # Hit Me or I'll Stay

  # Dealers Turn

  # Who is the winner
  #
  # Repeat
end
