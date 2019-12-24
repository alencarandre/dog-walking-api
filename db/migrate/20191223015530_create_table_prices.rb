class CreateTablePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :table_prices do |t|
      t.integer :cadence, uniq: true
      t.float :price
      t.float :price_additional

      t.timestamps
    end
  end
end
