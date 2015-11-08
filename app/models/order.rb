class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ "Check" , "Credit card" , "Purchase order" ]
  has_many :line_items 
  belongs_to :buyer
  validates :buyer, :name, :address, :line_items,  presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :pay_type, inclusion: PAYMENT_TYPES


  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
      self.total = self.total + item.total_price
    end
  end
end
