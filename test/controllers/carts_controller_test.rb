require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @cart = carts(:one)
    @buyer = buyers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cart" do
    assert_difference('Cart.count') do
      post :create, cart: {  }
    end

    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should show hash cart" do
    get :show, id: 'temp'
    assert_redirected_to store_path
  end
  
  test "should show buyer cart" do
    sign_in Buyer.first
    get :show, id: @buyer.cart_id
    assert_response :success
  end
  
  test "should not show buyer cart" do
    sign_in Buyer.first
    get :show, id: @buyer.cart_id + 1
    assert_redirected_to store_path
  end

  test "should get hash edit" do
    get :edit, id: 'temp'
    assert_redirected_to store_path
  end
  
  test "should get buyer edit" do
    sign_in Buyer.first
    get :edit, id: @cart
    assert_response :success
  end
  
  test "should not get buyer edit" do
    sign_in Buyer.first
    get :edit, id: @cart.id + 1
    assert_redirected_to store_path
  end

  test "should update cart" do
    patch :update, id: @cart, cart: {  }
    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should destroy hash cart" do
    delete :destroy, id: 'temp'
    assert_nil session[:cart_id]
    assert_redirected_to store_path
  end
  
  test "should destroy buyer cart" do
    sign_in Buyer.first
    assert_difference('Cart.count', -1) do
      delete :destroy, id: @cart
    end
    assert_redirected_to store_path
  end
end

