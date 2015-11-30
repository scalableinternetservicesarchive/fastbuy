class Buyers::SessionsController < Devise::SessionsController
  include CurrentCart
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end
  
  def show
  end

  # POST /resource/sign_in
  def create
     super
     if current_buyer != nil
       cart = current_buyer.cart
       if cart == nil
          cart = current_buyer.create_cart
          current_buyer.cart_id = cart.id
          current_buyer.save!
      end
      if session[:cart]
        session[:cart].each do |product_id, quantity|
          Cart.add_product(cart, {product_id: product_id.to_i, quantity: quantity.to_i})
        end
        session[:cart] = nil
      end
     end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
