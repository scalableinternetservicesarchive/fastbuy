class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :quantity, null: false

      t.timestamps null: false
    end
  end
end
