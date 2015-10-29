class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
    @sale_products = SaleProduct.order(:started_at)
    @sale_products.each do |sale_product|
      _current_time = DateTime.now
      _new_product = Product.find(sale_product.product_id)
      if sale_product.started_at <= _current_time && sale_product.expired_at > _current_time
        _new_product.on_sale = true
      elsif sale_product.expired_at <= _current_time
        sale_product.destroy
        _new_product.on_sale = false
      end
    _new_product.save
    end 
  end
  
  def sort
    sort_type = SORT_TYPE[params[:sort]]
    @products = Product.order(sort_type)
    render 'index'
  end
end
