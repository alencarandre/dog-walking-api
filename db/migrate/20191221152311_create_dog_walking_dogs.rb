class CreateDogWalkingDogs < ActiveRecord::Migration[6.0]
  def change
    create_table :dog_walking_dogs do |t|
      t.references :dog_walking, null: false, foreign_key: true
      t.references :dog, null: false, foreign_key: true

      t.timestamps
    end
  end
end
