class AddProductToLineItem < ActiveRecord::Migration
  def change
    add_reference :line_items, :product, index: true, foreign_key: true
  end
end
