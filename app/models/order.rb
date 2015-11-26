class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "Check" , "Credit card" , "Purchase order" ]
  has_many :line_items 
  belongs_to :buyer
  validates :buyer, :name, :address, :line_items,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :pay_type, inclusion: PAYMENT_TYPES
  validate :order_has_valid_quantity
  validate :order_is_valid_sale

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
      self.total = self.total + item.total_price
    end
  end

  def order_has_valid_quantity
    line_items.each do |item|
      if item.quantity > item.product.quantity
        errors.add(:quantity, "of #{item.product.title} in cart cannot exceed product quantity")
      end
    end
  end

  def order_is_valid_sale
    line_items.each do |item|
      if item.product.on_sale?
        if item.price != item.product.sale_products.first.price
          errors.add(:price, "of #{item.product.title} price has been changed")
        end
      else
        if item.price != item.product.price
          errors.add(:price, "of #{item.product.title} price has been changed")
        end
      end
    end
  end
end
