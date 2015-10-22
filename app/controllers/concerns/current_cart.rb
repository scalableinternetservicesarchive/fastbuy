module CurrentCart
    extend ActiveSupport::Concern

    private

    def set_cart
      puts "@@-Set Cart-@@"
      if current_buyer == nil
        @cart = session[:cart]  
        if @cart == nil
    	   @cart = Hash.new
    	   session[:cart] = @cart
           puts '@@-New Cart-@@'
        else
           puts '@@-Get Cart-@@'
    	end
      else 
        begin	  
		  @cart = Cart.find(current_buyer.cart_id)
		rescue ActiveRecord::RecordNotFound
          @cart = Cart.create(buyer: current_buyer)
          current_buyer.cart_id = @cart.id
	      current_buyer.save
	      puts '@@-Create User '+ current_buyer.id.to_s +  ' Cart ID ' + current_buyer.cart_id.to_s + '-@@'
		ensure
	      if @cart.class == Cart && session[:cart]
            hashcart = session[:cart]
	        hashcart.each do |product_id, quantity|
		      @line_item = @cart.add_product(product_id.to_i, quantity.to_i)
			  @line_item.save
		    end
		    session[:cart] = nil
		    puts '@@-Copy tempoary cart to User ' + current_buyer.id.to_s + ' Cart ID ' + current_buyer.cart_id.to_s + '-@@'
		  end
		end
      end
    end
end

