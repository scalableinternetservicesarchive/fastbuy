class AddCartIdToBuyers < ActiveRecord::Migration
  def change
    add_column :buyers, :cart_id, :integer
  end
end
