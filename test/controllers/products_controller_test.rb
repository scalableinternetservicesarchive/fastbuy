require 'test_helper'
class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
      title:       'Lorem Ipsum',
      description: 'Wibbles are fun!',
      image_url:   'lorem.jpg',
      quantity:    1,
      rating:      1.0,
      price:       19.95,
      sale:        false,
    }
    @seller = sellers(:one)
    sign_in @seller
  end

  test "must sign in" do
    sign_out @seller
    get :index
    assert_redirected_to new_seller_session_path

    get :new
    assert_redirected_to new_seller_session_path

    assert_difference('Product.count', 0) do
      post :create, product: @update
    end
    assert_redirected_to new_seller_session_path

    get :edit, id: @product
    assert_redirected_to new_seller_session_path

    patch :update, id: @product, product: @update
    assert_redirected_to new_seller_session_path

    LineItem.find(@product.id).destroy
    assert_difference('Product.count', 0) do
      delete :destroy, id: @product
    end
    assert_redirected_to new_seller_session_path
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: @update
    end
    assert_redirected_to product_path(assigns(:product))
  end

  test "should get product page" do
    get :show, id: @product
    assert_response :success
    assert_not_nil '#product_description'
    assert_not_nil '#product_image'
    assert_select '#product_price', /\$[,\d]+\.\d\d/
    assert_select '#product_rating', /\d\.\d/
    assert_select '#product_quantity', /\d+/

    sign_out @seller
    get :show, id: @product
    assert_response :success
    assert_not_nil '#product_description'
    assert_not_nil '#product_image'
    assert_select '#product_price', /\$[,\d]+\.\d\d/
    assert_select '#product_rating', /\d\.\d/
    assert_select '#product_quantity', /\d+/
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should not edit other seller's product" do
    sign_out @seller
    sign_in Seller.second
    get :edit, id: @product
    assert_redirected_to products_path
  end

  test "should update product" do
    patch :update, id: @product, product: @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should not update other seller's product" do
    sign_out @seller
    sign_in Seller.second
    patch :update, id: @product, product: @update
    assert_redirected_to products_path
  end

  test "should destroy product" do
    LineItem.find(@product.id).destroy
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end
    assert_redirected_to products_path
  end

  test "should not destroy other seller's product" do
    sign_out @seller
    sign_in Seller.second
    LineItem.find(@product.id).destroy
    assert_difference('Product.count', 0) do
      delete :destroy, id: @product
    end
    assert_redirected_to products_path
  end


end

