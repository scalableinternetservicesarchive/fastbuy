class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :buyer 

  def self.add_product(cart, product_id, quantity=1)
    product = Product.find(product_id)
    
    if cart.class == Hash
      if cart[product_id.to_s] == nil
        cart[product_id.to_s] = 0
      end
      new_quantity = cart[product_id.to_s].to_i + quantity
      if new_quantity == 0
        cart.delete(product_id.to_s)
        1
      elsif new_quantity > 0 && new_quantity <= product.quantity
        cart[product_id.to_s] = new_quantity
        product
      else
        2
      end
    else
      current_item = cart.line_items.find_by(product_id: product_id)
      if current_item
        new_quantity = current_item.quantity + quantity
        
        if new_quantity == 0
          current_item.destroy
          1
        elsif new_quantity > 0 && new_quantity <= product.quantity
          current_item.quantity = new_quantity
          if current_item.save
            current_item
          else
            nil
          end
        else
          2
        end
      else
        current_item = cart.line_items.create(product_id: product_id, quantity: quantity)
      end
    end
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end

