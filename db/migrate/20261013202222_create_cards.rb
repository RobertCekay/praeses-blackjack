class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.string :rank
      t.string :color
      t.string :suit
      t.integer :value
      t.references :hand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
