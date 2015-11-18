class AddCartToLineItem < ActiveRecord::Migration
  def change
    add_reference :line_items, :cart, index: true, foreign_key: true
  end
end
