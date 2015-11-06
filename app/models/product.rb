class Product < ActiveRecord::Base
  belongs_to :seller
  has_attached_file :image 
  # Validation restrictions
  validates :title, :description, :image_url, :quantity, :seller_id, presence: true
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
  end

  # Link with line_item table
  has_many :line_items
  has_many :orders, through: :line_items
  has_many :sale_products
  before_destroy :ensure_not_referenced_by_any_line_item
  
  after_initialize :init

    def init
      self.rating ||= 0.0           #will set the default value only if it's nil
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
      return false
    end
  end
end
