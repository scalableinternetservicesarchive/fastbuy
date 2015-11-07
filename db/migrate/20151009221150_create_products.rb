class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :image_url
      t.decimal :price, precision: 8, scale: 2, null: false
      t.decimal :rating, precision: 2, scale: 1
      t.integer :quantity, null: false

      t.timestamps null: false
    end
  end
end
