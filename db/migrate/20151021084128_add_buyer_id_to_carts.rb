class AddBuyerIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :buyer_id, :integer
  end
end
