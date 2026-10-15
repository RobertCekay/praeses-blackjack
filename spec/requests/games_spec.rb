require "rails_helper"

RSpec.describe 'Games', type: :request do
    describe "GET /games" do
    it "returns a successful response and renders the list" do
      get articles_path

      expect(response).to have_http_status(:ok)       # Status code 200
      expect(response.body).to include("Hello World")  # Verifies content in the DOM
    end
  end

  describe "GET /games/:id/play" do
    it "returns the specific article" do
      get article_path(article)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Lorem ipsum...")
    end
  end
  describe "method_name" do
    context "when doing something" do
      it "should result in" do
        expect(true).to be true
      end
    end
  end
end
