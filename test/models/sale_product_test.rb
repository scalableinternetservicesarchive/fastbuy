require 'test_helper'

class SaleProductTest < ActiveSupport::TestCase
  test "sale product attributes must not be empty" do
    sale_product = SaleProduct.new
    assert sale_product.invalid?
    assert sale_product.errors[:product].any?
    assert sale_product.errors[:started_at].any?
    assert sale_product.errors[:price].any?
    assert sale_product.errors[:expired_at].any?
    assert sale_product.errors[:quantity].any?
  end

  test "product must exist" do
    sale_product = SaleProduct.new(product_id: 999,
                          price: 1,
                          quantity: 1,
                          started_at: Date.today + 1000,
                          expired_at: Date.today + 10000)
    assert !Product.exists?(999)
    assert sale_product.invalid?
    assert sale_product.errors[:product].any?

    sale_product.product_id = Product.first.id
    assert sale_product.valid?
    assert_equal sale_product.product, Product.first

    sale_product.product = Product.second
    assert sale_product.valid?
    assert_equal sale_product.product_id, Product.second.id
  end

  test "sale product price must be positive" do
    product = Product.first
    sale_product = SaleProduct.new(product: product,
                          quantity: 1,
                          started_at: Date.today + 1000,
                          expired_at: Date.today + 10000)
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
    product = Product.first
    sale_product = SaleProduct.new(product: product,
                          quantity: 1,
                          started_at: Date.today + 1000,
                          expired_at: Date.today + 10000)
    sale_product.price = product.price + 1
    assert sale_product.invalid?
    assert_equal ["can't be greater than original price"],
      sale_product.errors[:price]

    sale_product.price =  product.price - 0.1
    assert sale_product.valid?
  end

  test "sale product quantity must be positive" do
    product = Product.first
    sale_product = SaleProduct.new(product: product,
                          price: 1,
                          started_at: Date.today + 1000,
                          expired_at: Date.today + 10000)
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
    product = Product.first
    sale_product = SaleProduct.new(product: product,
                          price: 1,
                          quantity: 1,
                          expired_at: Date.today + 10000)
    sale_product.started_at = Date.today - 1000
    assert sale_product.invalid?
    assert_equal ["can't be in the past"],
      sale_product.errors[:started_at]

    sale_product.started_at = Date.today + 1000
    assert sale_product.valid?
  end
 
  test "sale product expired time cannot be ealier than start time" do
    product = Product.first
    sale_product = SaleProduct.new(product: product,
                          price: 1,
                          quantity: 1,
                          started_at: Date.today + 1000)
    sale_product.expired_at = Date.today
    assert sale_product.invalid?
    assert_equal ["can't be earlier than start time"],
      sale_product.errors[:expired_at]

    sale_product.expired_at = Date.today + 10000
    assert sale_product.valid?
  end

end
