class AddBuyerToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :buyer, index: true, foreign_key: true
  end
end
