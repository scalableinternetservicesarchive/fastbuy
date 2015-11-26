module CurrentSales extend ActiveSupport::Concern

  private

  def get_sales
    @sale_products = SaleProduct.where("started_at < ?", Time.now)
    @sale_products.each do |sale_product|
      current_time = Time.now
      if sale_product.started_at <= current_time && sale_product.expired_at > current_time
        if sale_product.product.on_sale == false
          sale_product.product.on_sale = true
          sale_product.product.save
        end
      elsif sale_product.expired_at <= current_time
        sale_product.product.on_sale = false
        sale_product.product.save
        sale_product.destroy
      end
    end
  end

end
