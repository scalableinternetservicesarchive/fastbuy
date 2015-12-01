module CurrentCart extend ActiveSupport::Concern

  private
  def set_cart
    if current_seller
      session[:cart] = nil
    elsif current_buyer == nil
      @cart = session[:cart]  
      if @cart == nil
        @cart = Hash.new
        session[:cart] = @cart
      end
    else 
      @cart = Cart.includes(:line_items,line_items: [:product, product: [:sale_products]]).find(current_buyer.cart_id)
    end
  end

end
