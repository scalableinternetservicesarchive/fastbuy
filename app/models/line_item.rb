class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart

  validates :product_id, presence: true, numericality: {greater_than_or_equal_to: 1}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: :product_quantity}
  
  def total_price
    price * quantity
  end

  def product_quantity
    product.quantity
  end
end
