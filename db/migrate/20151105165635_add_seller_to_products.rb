class AddSellerToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :seller, index: true, foreign_key: true
  end
end
