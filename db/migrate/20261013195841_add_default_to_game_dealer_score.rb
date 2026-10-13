class AddDefaultToGameDealerScore < ActiveRecord::Migration[8.1]
  def change
    change_column_default :games, :dealer_score, from: nil, to: 0
  end
end
