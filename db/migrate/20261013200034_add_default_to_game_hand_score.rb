class AddDefaultToGameHandScore < ActiveRecord::Migration[8.1]
  def change
    change_column_default :hands, :score, from: nil, to: 0
  end
end
