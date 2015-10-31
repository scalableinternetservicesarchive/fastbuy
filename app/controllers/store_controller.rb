class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart
  before_action :set_cart
  
  def index
    if params[:search] == nil
      @products = Product.order(:title)
    else
      @search = Product.search do
        fulltext params[:search]
      end
      @products = @search.results
    end
  end
  
  def sort
    sort_type = SORT_TYPE[params[:sort]]
    @products = Product.order(sort_type)
    render 'index'
  end
end
