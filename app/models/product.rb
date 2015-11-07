class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :sale_products
  belongs_to :seller
  has_attached_file :image, use_timestamp: false

  before_destroy :ensure_not_referenced_by_any_line_item

  # Validation restrictions
  validates :title, :description, :image_url, :quantity, :seller, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :rating, allow_blank: true, numericality: {greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0}
  validates :quantity, numericality: {greater_than_or_equal_to: 0}
  validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  # Solr Search
  searchable do
    text :title, :as => :title_textp
    text :description, :as => :description_textp
    boolean :on_sale
    integer :seller_id
    integer :quantity
    double  :rating
    double  :price
    string  :title_sort do
      title.downcase
    end
  end

  def self.latest
      Product.order(:updated_at).last
  end

  private
  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      logger.error "Line Items Present, Destroy it First"
      raise "Cannot Destroy the product. References of product #{title} exists!"
      return false
    end
  end
end
