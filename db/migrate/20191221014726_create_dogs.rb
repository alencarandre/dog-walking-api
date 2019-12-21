class CreateDogs < ActiveRecord::Migration[6.0]
  def change
    create_table :dogs do |t|
      t.string :name
      t.string :breed
      t.integer :age
      t.references :dog_breed, foreign_key: true, index: true

      t.timestamps
    end
  end
end
