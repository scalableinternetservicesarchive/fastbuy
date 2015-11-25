require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @buyer = buyers(:one)
  end

  test "should show hash cart" do
    get :show, id: 'temp'
    assert_response :success
  end
  
  test "should show buyer cart" do
    sign_in @buyer
    get :show, id: @buyer.cart_id, cart: {id: @buyer.cart_id}
    assert_response :success
  end
  
  test "should destroy hash cart" do
    delete :destroy, id: 'temp'
    assert_nil session[:cart_id]
    assert_redirected_to store_path
  end
  
  test "should destroy buyer cart" do
    sign_in @buyer
    assert_difference('@buyer.cart.line_items.count', 0) do
      delete :destroy, id: @buyer.cart_id, cart: {id: @buyer.cart_id}
    end
    assert_redirected_to store_path
  end
end
