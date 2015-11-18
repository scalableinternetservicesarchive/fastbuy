class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :buyer 

  def self.add_product(cart, line_item)
    product = Product.find(line_item[:product_id])
    sale_product = product.on_sale ? SaleProduct.find_by(product: product) : nil
    price = sale_product ? sale_product.price : product.price
    available_quantity = sale_product ? sale_product.quantity : product.quantity
    quantity = line_item[:quantity].to_i
    if cart.class == Hash
      new_quantity = cart[product.id.to_s] ? cart[product.id.to_s].split(':')[0].to_i + quantity : quantity 
      if new_quantity == 0
        cart.delete(product.id.to_s)
        1
      elsif new_quantity > 0 && new_quantity <= available_quantity
        cart[product.id.to_s] = new_quantity.to_s + ":" + price.to_s 
        product
      else
        2
      end
    else
      current_item = cart.line_items.find_by(product_id: product.id)
      if current_item
        new_quantity = current_item.quantity + quantity
        if new_quantity == 0
          current_item.destroy
          1
        elsif new_quantity > 0 && new_quantity <= available_quantity
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
        if quantity <= available_quantity
          current_item = cart.line_items.create(product_id: product.id, quantity: quantity, price: price)
        else
          2
        end
      end
    end
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end
