class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :buyer 

  def add_product(product_id, quantity=1)
    current_item = line_items.find_by(product_id: product_id)
    if current_item
      current_item.quantity += quantity
    else
      current_item = line_items.build(product_id: product_id)
      current_item.quantity = quantity
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end

