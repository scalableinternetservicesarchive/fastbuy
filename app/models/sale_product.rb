class SaleProduct < ActiveRecord::Base
  belongs_to :product
  validates :product_id, :price, :quantity, :expired_at, :started_at, presence: true
  validates :product_id, numericality: {greater_than: 0}
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validate :start_time_cannot_be_in_the_past, :expiration_time_cannot_be_earlier_than_start_time 
  validate :sale_price_cannot_be_greater_than_original_price

  def self.newSale(product)
    new(product_id: product.id, price: product.price, quantity: product.quantity)
  end

  def start_time_cannot_be_in_the_past
    if started_at.present? && started_at < Date.today
      errors.add(:started_at, "can't be in the past")
    end
  end

  def expiration_time_cannot_be_earlier_than_start_time
    if expired_at.present? && expired_at <= started_at
      errors.add(:expired_at, "can't be earlier than start time")
    end
  end

  def sale_price_cannot_be_greater_than_original_price
    if product_id.present? 
      product = Product.find(product_id)
      if product.price < price
        errors.add(:price, "can't be greater than original price")
      end
    end
  end

end