require 'test_helper'

class SaleProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:one)
    @seller = @product.seller
  end

  test "sale product attributes must not be empty" do
    sale_product = SaleProduct.new
    assert sale_product.invalid?
    assert sale_product.errors[:product].any?
    assert sale_product.errors[:seller].any?
    assert sale_product.errors[:started_at].any?
    assert sale_product.errors[:price].any?
    assert sale_product.errors[:expired_at].any?
    assert sale_product.errors[:quantity].any?
  end

  test "product must exist" do
    sale_product = SaleProduct.new(product_id: 999,
                          seller: @seller,
                          price: 1,
                          quantity: 1,
                          started_at: Time.now + 1000,
                          expired_at: Time.now + 10000)
    assert !Product.exists?(999)
    assert sale_product.invalid?
    assert_equal ["can't be blank"],
      sale_product.errors[:product]
    assert_not sale_product.errors[:seller].any?

    sale_product.product_id = @product.id
    assert sale_product.valid?
    assert_equal sale_product.seller, sale_product.product.seller
   
    sale_product.product = @product
    assert sale_product.valid?
    assert_equal sale_product.seller, sale_product.product.seller
  end

  test "seller must exist" do
    sale_product = SaleProduct.new(product: @product,
                          seller_id: 999,
                          price: 1,
                          quantity: 1,
                          started_at: Time.now + 1000,
                          expired_at: Time.now + 10000)
    assert !Seller.exists?(999)
    assert sale_product.invalid?
    assert_equal ["can't be blank"],
      sale_product.errors[:seller]
    assert_not sale_product.errors[:product].any?

    sale_product.seller_id = @seller.id
    assert sale_product.valid?
 
    sale_product.seller = @seller
    assert sale_product.valid?
  end

  test "sale seller must be the same as product seller" do
    @seller = sellers(:two)
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          price: 1,
                          quantity: 1,
                          started_at: Time.now + 1000,
                          expired_at: Time.now + 10000)
    assert sale_product.invalid?
    assert_equal ["can't have different seller"],
      sale_product.errors[:seller]

    sale_product.seller = @product.seller
    assert sale_product.valid?
    
    sale_product.seller_id = @product.seller.id
    assert sale_product.valid?
  end

  test "sale product price must be positive" do
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          quantity: 1,
                          started_at: Time.now + 1000,
                          expired_at: Time.now + 10000)
    sale_product.price = -1
    assert sale_product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      sale_product.errors[:price]

    sale_product.price = 0
    assert sale_product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      sale_product.errors[:price]

    sale_product.price = 1
    assert sale_product.valid?
  end

  test "sale product price can't be greater than original price" do
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          quantity: 1,
                          started_at: Time.now + 1000,
                          expired_at: Time.now + 10000)
    sale_product.price = @product.price + 1
    assert sale_product.invalid?
    assert_equal ["can't be greater than original price"],
      sale_product.errors[:price]

    sale_product.price = @product.price - 0.1
    assert sale_product.valid?
  end

  test "sale product quantity must be positive" do
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          price: 1,
                          started_at: Time.now + 1000,
                          expired_at: Time.now + 10000)
    sale_product.quantity = -1
    assert sale_product.invalid?
    assert_equal ["must be greater than or equal to 0"],
      sale_product.errors[:quantity]

    sale_product.quantity = 0
    assert sale_product.valid?

    sale_product.quantity = 1
    assert sale_product.valid?
  end

  test "sale product start time cannot be in the past" do
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          price: 1,
                          quantity: 1,
                          expired_at: Time.now + 10000)
    sale_product.started_at = Time.now - 1000
    assert sale_product.invalid?
    assert_equal ["can't be in the past"],
      sale_product.errors[:started_at]

    sale_product.started_at = Time.now + 1000
    assert sale_product.valid?
  end
 
  test "sale product expired time cannot be ealier than start time" do
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          price: 1,
                          quantity: 1,
                          started_at: Time.now + 1000)
    sale_product.expired_at = Time.now + 100
    assert sale_product.invalid?
    assert_equal ["can't be earlier than start time"],
      sale_product.errors[:expired_at]

    sale_product.expired_at = Time.now + 10000
    assert sale_product.valid?
  end
  
  test "sale prdouct must expire" do
    sale_product = SaleProduct.new(product: @product,
                          seller: @seller,
                          price: 1,
                          quantity: 1,
                          started_at: Time.now,
                          expired_at: Time.now + 3
                          )
    assert sale_product.valid?
    sleep 6
    assert sale_product.invalid?
    assert_equal ["has expired"],
      sale_product.errors[:expired_at]
  end 
end
