class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart, CurrentSales
  before_action :set_cart, :get_sales
  
  def index
    expires_in 3.minutes, public: true, must_revalidate: true
    @page = params[:page] ? params[:page] : 1
    @search_param = params[:search] ? params[:search].squish : nil
    if @search_param == nil
      @products = Product.includes(:sale_products).paginate(page: @page, per_page:20)
     else
      if @search_param == 'on_sale'
        @search = Product.search do
          with(:on_sale, true)
          paginate :page => params[:page], :per_page => 20
        end
      else
        @search = Product.search do
          fulltext params[:search] ? params[:search].squish : nil
          paginate :page => params[:page], :per_page => 20
        end
      end
      @products = @search.results
    end
  end
  
  def sort
    @sort_type = SORT_TYPE[params[:sort]]
    @page = params[:page] ? params[:page] : 1
    @products = Product.order(@sort_type).paginate(page: @page, per_page:20)
    render 'index'
  end
end

