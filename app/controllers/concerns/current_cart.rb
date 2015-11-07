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
      if (@cart = current_buyer.cart) == nil
        @cart = current_buyer.create_cart
        current_buyer.cart_id = @cart.id
        current_buyer.save
      end  
      if session[:cart]
        session[:cart].each do |product_id, quantity|
          Cart.add_product(@cart, {product_id: product_id.to_i, quantity: quantity.to_i})
        end
        session[:cart] = nil
      end
    end
  end
end
