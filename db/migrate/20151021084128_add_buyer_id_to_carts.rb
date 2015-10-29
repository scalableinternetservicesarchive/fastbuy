class AddBuyerIdToCarts < ActiveRecord::Migration
  def change
    add_reference :carts, :buyer, index: true, foreign_key: true
  end
end
