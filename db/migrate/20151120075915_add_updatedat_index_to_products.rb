class AddUpdatedatIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :updated_at    
  end
end
