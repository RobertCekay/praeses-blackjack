require "rails_helper"

RSpec.describe 'Games', type: :request do
  describe "GET /games" do
    it "returns a successful response and renders the list" do
      get games_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Blackjack")
    end
  end

  describe "GET /games/:id/play" do
    it "Should trigger a player hit with param :hit" do
      expect_any_instance_of(Game).to receive(:player_hit)

      get play_game_path(create(:game), hit: 'true')

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Blackjack")
    end

    it "Should trigger a player hit with param :stay" do
      expect_any_instance_of(Game).to receive(:player_stay)

      get play_game_path(create(:game), stay: 'true')

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Blackjack")
    end
  end
end
