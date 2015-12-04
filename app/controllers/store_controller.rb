class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart, CurrentSales, SearchParams
  before_action :set_cart
  before_action :set_search_params

  def index
    if params[:search] == nil
      @products = Product.paginate(page: params[:page], per_page: 20)
     else
      if @search_param == 'on_sale'
        @search = Product.search do
          with(:on_sale, true)
          paginate page: params[:page], per_page: 20
        end
      else
        @search = Product.search do
          fulltext params[:search]
          paginate page: params[:page], per_page: 20
        end
      end
      @products = @search.results
    end
    get_sales
  end
  
  def sort
    @sort_type = SORT_TYPE[params[:sort]]
    @products = Product.order(@sort_type).paginate(page: params[:page], per_page: 20)
    get_sales
    render 'index'
  end

end

