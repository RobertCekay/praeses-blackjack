class AddTypetoHand < ActiveRecord::Migration[8.1]
  def change
    add_column :hands, :role, :string
  end
end
