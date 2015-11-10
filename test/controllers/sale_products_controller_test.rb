require 'test_helper'

class SaleProductsControllerTest < ActionController::TestCase
  setup do
    @sale_product = sale_products(:one)
    @product = @sale_product.product
    @seller = @sale_product.seller
    sign_in @seller
    @update = {
      product_id: @product.id,
      price: 0.1,
      quantity: 1,
      started_at: Time.now + 10,
      expired_at: Time.now + 1000
    }
  end

  test "must sign in" do
    sign_out @seller
    get :index
    assert_redirected_to new_seller_session_path
    
    get :new
    assert_redirected_to new_seller_session_path

    assert_difference('SaleProduct.count', 0) do
      post :create, sale_product: @update
    end
    assert_redirected_to new_seller_session_path

    get :show, id: @sale_product
    assert_redirected_to new_seller_session_path

    get :edit, id: @sale_product
    assert_redirected_to new_seller_session_path

    assert_difference('SaleProduct.count', 0) do
      delete :destroy, id: @sale_product
    end
    assert_redirected_to new_seller_session_path

    patch :update, id: @sale_product, sale_product: @update
    assert_redirected_to new_seller_session_path
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sale_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale_product" do
    @sale_product.destroy
    assert_difference('SaleProduct.count', +1) do
      post :create, sale_product: @update
    end
    assert_redirected_to sale_product_path(assigns(:sale_product))
  end

  test "should not create sale_product" do
    sign_out @seller
    sign_in Seller.second
    SaleProduct.destroy(@sale_product.id)
    assert_difference('SaleProduct.count', 0) do
      post :create, sale_product: @update
    end
    assert_redirected_to sale_products_path
    sign_out Seller.second
  end

  test "should show sale_product" do
    get :show, id: @sale_product
    assert_response :success
  end

  test "should not show sale_product" do
    sign_out @seller
    sign_in Seller.second
    get :show, id: @sale_product
    assert_redirected_to sale_products_path
    sign_out Seller.second
  end

  test "should get edit" do
    get :edit, id: @sale_product
    assert_response :success
  end 

  test "should not get edit" do
    sign_out @seller
    sign_in Seller.second
    get :edit, id: @sale_product
    assert_redirected_to sale_products_path
    sign_out Seller.second
  end

  test "should update sale_product" do
    patch :update, id: @sale_product, sale_product: @update
    assert_redirected_to sale_product_path(assigns(:sale_product))
  end

  test "should not update sale_product" do
    sign_out @seller
    sign_in Seller.second
    patch :update, id: @sale_product, sale_product: @update
    assert_redirected_to sale_products_path
    sign_out Seller.second
  end

  test "should destroy sale_product" do
    assert_difference('SaleProduct.count', -1) do
      delete :destroy, id: @sale_product
    end
    assert_redirected_to sale_products_path
  end

  test "should not destroy sale_product" do
    sign_out @seller
    sign_in Seller.second
    assert_difference('SaleProduct.count', 0) do
      delete :destroy, id: @sale_product
    end
    assert_redirected_to sale_products_path
    sign_out Seller.second
  end
end
