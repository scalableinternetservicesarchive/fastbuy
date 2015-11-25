class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart, CurrentSales
  before_action :set_cart, :get_sales
  
  def index
    expires_in 3.minutes, public: true, must_revalidate: true
    @page = params[:page] ? params[:page] : 1
    @search_param = params[:search] ? params[:search].squish : nil
    if @search_param == nil
      @products = Product.includes(:sale_products).paginate(page: @page, per_page:20) if stale?([Product.includes(:sale_products).paginate(page: @page, per_page:20), @cart, @cart.class == Cart ? @cart.line_items : nil, current_seller, current_buyer])
     else
      if @search_param == 'on_sale'
        @search = Product.search(include: [:sale_products]) do
          with(:on_sale, true)
          paginate :page => params[:page], :per_page => 20
        end
      else
        @search = Product.search do
          fulltext params[:search] ? params[:search].squish : nil
          paginate :page => params[:page], :per_page => 20
        end
      end
      @products = @search.results if stale?([@search, @cart, @cart.class == Cart ? @cart.line_items : nil, current_seller, current_buyer])
    end
  end
  
  def sort
    @sort_type = SORT_TYPE[params[:sort]]
    @page = params[:page] ? params[:page] : 1
   if stale?([Product.order(@sort_type).paginate(page:params[:page], per_page:20),@cart, @cart.class == Cart ? @cart.line_items : nil, current_seller, current_buyer]) 
    @products = Product.order(@sort_type).paginate(page: @page, per_page:20)
    render 'index'
   end
  end
end

