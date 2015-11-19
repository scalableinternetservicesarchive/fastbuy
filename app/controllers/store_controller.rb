class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart, CurrentSales
  before_action :set_cart, :get_sales
  
  def index
    search_param = params[:search] ? params[:search].squish : nil
    if search_param == nil
      @products = Product.paginate(page:params[:page], per_page:20)
    else
      if search_param == 'on_sale'
        @search = Product.search(include: [:sale_products]) do
          with(:on_sale, true)
          paginate :page => params[:page], :per_page => 20
        end
      else
        @search = Product.search do
          fulltext search_param
          paginate :page => params[:page], :per_page => 20
        end
      end
      @products = @search.results
    end
  end
  
  def sort
    sort_type = SORT_TYPE[params[:sort]]
    @products = Product.order(sort_type).paginate(page:params[:page], per_page:20)
    render 'index'
  end
end
