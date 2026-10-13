class AddGameIdToHand < ActiveRecord::Migration[8.1]
  def change
    add_reference :hands, :game, null: false, foreign_key: true
  end
end
