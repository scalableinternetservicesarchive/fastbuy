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
      @cart = current_buyer.cart
    end
  end

end
