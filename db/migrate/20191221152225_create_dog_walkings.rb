class CreateDogWalkings < ActiveRecord::Migration[6.0]
  def change
    create_table :dog_walkings do |t|
      t.string :status
      t.float :latitude
      t.float :longitude
      t.integer :duration
      t.float :price
      t.float :final_price
      t.datetime :scheduled_at
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
