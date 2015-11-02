module CurrentCart
    extend ActiveSupport::Concern

    private

    def set_cart
      if current_buyer == nil
        @cart = session[:cart]  
        if @cart == nil
    	   @cart = Hash.new
    	   session[:cart] = @cart
        else
    	end
      else 
        begin	  
          @cart = Cart.find(current_buyer.cart_id)
	rescue ActiveRecord::RecordNotFound
          @cart = Cart.create(buyer: current_buyer)
          current_buyer.cart_id = @cart.id
          current_buyer.save
        ensure
          if @cart.class == Cart && session[:cart]
            hashcart = session[:cart]
            hashcart.each do |product_id, attributes|
              quantity =  attributes.split(':')[0].to_i 
              price =  attributes.split(':')[1].to_f
              @line_item = Cart.add_product(@cart, product_id.to_i, quantity, price)
              @line_item.save
            end
        session[:cart] = nil
        end
      end
    end
  end
end

