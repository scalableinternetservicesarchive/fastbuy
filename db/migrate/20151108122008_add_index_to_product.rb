class AddIndexToProduct < ActiveRecord::Migration
  def change
    add_index :products, :on_sale
  end
end
