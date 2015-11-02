class AddProductToSaleProducts < ActiveRecord::Migration
  def change
    add_reference :sale_products, :product, index: true, foreign_key: true
  end
end
