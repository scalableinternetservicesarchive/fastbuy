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
        hashcart = session[:cart]
        hashcart.each do |product_id, attributes|
          quantity =  attributes.split(':')[0].to_i 
          price =  attributes.split(':')[1].to_f
          Cart.add_product(@cart, product_id.to_i, quantity, price)
        end
        session[:cart] = nil
      end
    end
  end
end
