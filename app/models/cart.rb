class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :buyer 

  def self.add_product(cart, line_item)
    product = Product.find(line_item[:product_id])
    price = product.on_sale ? SaleProduct.find_by(product_id: product.id).price : product.price
    if cart.class == Hash
      if cart[product.id.to_s] == nil
        cart[product.id.to_s] = "0:" + price.to_s
      end
      new_quantity = cart[product.id.to_s].split(':')[0].to_i + line_item[:quantity]
      if new_quantity == 0
        cart.delete(product.id.to_s)
        1
      elsif new_quantity > 0 && new_quantity <= product.quantity
        cart[product.id.to_s] = new_quantity.to_s + ":" + price.to_s 
        product
      else
        2
      end
    else
      current_item = cart.line_items.find_by(product_id: product.id)
      if current_item
        new_quantity = current_item.quantity + line_item[:quantity]
        if new_quantity == 0
          current_item.destroy
          1
        elsif new_quantity > 0 && new_quantity <= product.quantity
          current_item.quantity = new_quantity
          current_item.price = price
          if current_item.save
            current_item
          else
            nil
          end
        else
          2
        end
      else
        current_item = cart.line_items.create(product_id: product.id, quantity: line_item[:quantity], price: price)
      end
    end
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end

