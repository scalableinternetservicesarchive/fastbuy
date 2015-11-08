class AddSellerToSaleProduct < ActiveRecord::Migration
  def change
    add_reference :sale_products, :seller, index: true, foreign_key: true
  end
end
