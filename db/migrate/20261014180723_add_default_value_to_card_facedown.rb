class AddDefaultValueToCardFacedown < ActiveRecord::Migration[8.1]
  def change
    change_column_default :cards, :facedown, from: nil, to: false
  end
end
