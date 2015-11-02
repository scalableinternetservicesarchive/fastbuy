require 'test_helper'

class NavigationControllerTest < ActionController::TestCase
  test "should get store" do
    get :store
    assert_redirected_to store_path
  end

  test "should get sales" do
    sign_in Seller.first
    get :sales
    assert_redirected_to sale_products_path
  end

  test "should get cart" do
    get :cart
    assert_response :success
  end

  test "should get buyer" do
    get :buyer
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
