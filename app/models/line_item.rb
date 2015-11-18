class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  validates :product, :cart, presence: true
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0.01}

  def total_price
    price * quantity
  end

  def product_quantity
    product.quantity
  end
end
