module CurrentSales extend ActiveSupport::Concern

  private

  def get_sales
   @products.each do |product|
     sale_product = product.sale_products.first
     if sale_product.nil?
        next
     end
     current_time = Time.now
     if sale_product.started_at <= current_time && sale_product.expired_at > current_time
       if product.on_sale == false
          product.on_sale = true
          product.save
       end
     elsif sale_product.expired_at <= current_time
        product.on_sale = false
        product.save
        sale_product.destroy
      end
    end
  end

end
