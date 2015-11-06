class AddCartToBuyers < ActiveRecord::Migration
  def change
    add_reference :buyers, :cart, index: true, foreign_key: true
  end
end
