require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
  end

  test "order attributes must not be empty" do
    order = Order.new
    assert order.invalid?
    assert order.errors[:name].any?
    assert order.errors[:address].any?
    assert order.errors[:buyer].any?
    assert order.errors[:email].any?
    assert order.errors[:pay_type].any?
  end

  test "should be valid" do
    assert @order.valid?
  end

  test "name should be present" do
    @order.name = "  "
    assert_not @order.valid?
  end
 
  test "address should be present" do 
    @order.address = "  "
    assert_not @order.valid?
  end 
  
  test "email should be present" do
    @order.email = " "
    assert_not @order.valid?
  end

  test "email should not be too long" do
    @order.email = "a" * 244 + "@example.com"
    assert_not @order.valid?
  end

  test "email validation should accept valid addresses" do
    valid_address = %w[order@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_address.each do |valid_address|
      @order.email = valid_address
      assert @order.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "pay_type should be valid" do
    @order.pay_type = "bank"
    assert_not @order.valid?
  end
  
  test "pay_type should be right" do
    @order.pay_type = "Check"
    assert @order.valid?
  end
	
end

