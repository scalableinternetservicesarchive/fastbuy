class Product < ActiveRecord::Base
  # Validation restrictions
  validates :title, :description, :image_url, :quantity, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :rating, allow_blank: true, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0}
  validates :quantity, numericality: {greater_than_or_equal_to: 1}
  validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

  # Link with line_item table
  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end
end
