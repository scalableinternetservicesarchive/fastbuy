class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.decimal :price, precision: 8, scale: 2
      t.decimal :rating, precision: 1, scale: 1
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
