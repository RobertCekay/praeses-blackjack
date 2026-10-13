require "rails_helper"

RSpec.describe "game/index.html.erb", type: :view do
  before do
    # Assign instance variables that the view expects from the controller
  end

  it "displays all users" do
    render # Renders the template

    # Set expectations against the rendered HTML
    expect(rendered).to match(/Blackjack/)
  end
end
