class AddProfileToBuyer < ActiveRecord::Migration
  def change
    add_column :buyers, :name, :string
    add_column :buyers, :address, :string
  end
end
