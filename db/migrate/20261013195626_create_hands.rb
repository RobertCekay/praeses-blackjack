class CreateHands < ActiveRecord::Migration[8.1]
  def change
    create_table :hands do |t|
      t.integer :score

      t.timestamps
    end
  end
end
