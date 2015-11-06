class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart
  before_action :set_cart
  
  def index
    if params[:search] == nil
      @search = Product.search do
        order_by :title_sort
        paginate :page => params[:page], :per_page => 20
      end 
       @products = @search.results
    else
      if params[:search] == 'sale'
        @search = Product.search do
          any_of do
            with(:on_sale, true)
            paginate :page => params[:page], :per_page => 20
          end
        end
      else
        @search = Product.search do
          fulltext params[:search]
      #      order_by :price
            paginate :page => params[:page], :per_page => 20
        end

      end
       @products = @search.results
 
    end
    @sale_products = SaleProduct.order(:started_at)
    @sale_products.each do |sale_product|
      current_time = DateTime.now
      new_product = Product.find(sale_product.product_id)
      if sale_product.started_at <= current_time && sale_product.expired_at > current_time
        new_product.on_sale = true
      elsif sale_product.expired_at <= current_time
        sale_product.destroy
        new_product.on_sale = false
      end
    new_product.save
    end
    
  end
  
  def sort
#    @products.search do
#      order_by SORT_TYPE[params[:sort]]
#      paginate :page => params[:page], :per_page => 20
#    end
    sort_type = SORT_TYPE[params[:sort]]
#    @products = Product.order(sort_type)
    @products = Product.order(sort_type).paginate(page:params[:page], per_page:20)
    render 'index'
  end
end
