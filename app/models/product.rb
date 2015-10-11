class Product < ActiveRecord::Base
  validates :title, :description, :image_url, :quantity, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :rating, allow_blank: true, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0}
  validates :quantity, numericality: {greater_than_or_equal_to: 1}
  validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
end
