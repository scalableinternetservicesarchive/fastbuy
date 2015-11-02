class AddOnSaleToProduct < ActiveRecord::Migration
  def change
    add_column :products, :on_sale, :boolean, default: false
  end
end
