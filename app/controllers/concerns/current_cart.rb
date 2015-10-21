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
        @cart = Cart.find(current_buyer.cart_id)
		puts '@@-Current User ' + current_buyer.id.to_s + ' Cart ID ' + current_buyer.cart_id.to_s + '-@@'
      end
      rescue ActiveRecord::RecordNotFound
        @cart = Cart.create(user_id: current_buyer.id)
        current_buyer.cart_id = @cart.id
	    current_buyer.save
	    puts '@@-Create User '+ current_buyer.id.to_s +  ' Cart ID ' + current_buyer.cart_id.to_s + '-@@'
    end
end

