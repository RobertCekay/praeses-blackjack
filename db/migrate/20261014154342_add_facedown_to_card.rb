class AddFacedownToCard < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :facedown, :boolean
  end
end
