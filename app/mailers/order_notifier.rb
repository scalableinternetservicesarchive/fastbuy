class OrderNotifier < ApplicationMailer
  default from: 'Hikari <fastbuy.noreply@gmail.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def received(order)
    @order = order

    mail(to: order.email,
         subject: 'Your FastBuy Order Confirmation') do |format|
      format.text { render 'received'}
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.shipped.subject
  #
  def shipped(order)
    @order = order

    mail(to: order.email,
         subject: 'Your FastBuy Order Shipped') do |format|
      format.html { render 'shipped'}
    end
  end

end

