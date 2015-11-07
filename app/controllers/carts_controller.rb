class CartsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  
  # GET /cart
  def show
    if @cart.class == Hash
      render "carts/_cart" 
    end
  end

 end
