class SaleProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :seller

  validates :product, :seller, :price, :quantity, :expired_at, :started_at, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validate :sale_product_has_the_same_seller_with_product
  validate :start_time_cannot_be_in_the_past, :expiration_time_cannot_be_earlier_than_start_time, :has_not_expired 
  validate :sale_price_cannot_be_greater_than_original_price

  def self.newSale(product)
    new(seller_id: product.seller.id, product_id: product.id, price: product.price, quantity: product.quantity)
  end

  def start_time_cannot_be_in_the_past
    if started_at.present? && created_at.nil? && started_at < Time.now - 60
      errors.add(:started_at, "can't be in the past")
    end
  end

  def expiration_time_cannot_be_earlier_than_start_time
    if expired_at.present? && expired_at <= started_at
      errors.add(:expired_at, "can't be earlier than start time")
    end
  end

  def has_not_expired
    if expired_at.present? && expired_at < Time.now
      errors.add(:expired_at, "has expired")
    end
  end

  def sale_price_cannot_be_greater_than_original_price
    if product && product.price < price
        errors.add(:price, "can't be greater than original price")
     end
  end

  def sale_product_has_the_same_seller_with_product
    if product && seller && product.seller != seller
        errors.add(:seller, "can't have different seller")
    end
  end
end
