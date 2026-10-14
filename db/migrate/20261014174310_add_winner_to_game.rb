class AddWinnerToGame < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :winner, :string
  end
end
