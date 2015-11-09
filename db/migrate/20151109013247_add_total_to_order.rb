class AddTotalToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :total, :decimal, precision: 15, scale: 2, default: 0
  end
end
