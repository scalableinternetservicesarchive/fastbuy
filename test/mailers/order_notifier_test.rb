require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "received" do
    mail = OrderNotifier.received(orders(:one))
    assert_equal "Your FastBuy Order Confirmation", mail.subject
    assert_equal ["john@site.tw"], mail.to
    puts mail.to.class
    assert_equal ["fastbuy.noreply@gmail.com"], mail.from
    # TODO: NEED EMAIL CONTENTS CHECKING
    assert_match /Dear John,\s/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:one))
    assert_equal "Your FastBuy Order Shipped", mail.subject
    assert_equal ["john@site.tw"], mail.to
    assert_equal ["fastbuy.noreply@gmail.com"], mail.from
    # TODO: NEED EMAIL CONTENTS CHECKING
    assert_match /<h3>FastBuy Order Shipped<\/h3>\s/, mail.body.encoded
  end

end

