class CreateSaleProducts < ActiveRecord::Migration
  def change
    create_table :sale_products do |t|
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :quantity, null: false
      t.datetime :started_at, null: false
      t.datetime :expired_at, null: false

      t.timestamps null: false
    end
  end
end
