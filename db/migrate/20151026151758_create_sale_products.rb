class CreateSaleProducts < ActiveRecord::Migration
  def change
    create_table :sale_products do |t|
      t.integer :product_id
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity
      t.datetime :started_at
      t.datetime :expired_at

      t.timestamps null: false
    end
  end
end
