module ProductsHelper

  def cache_key_for_products
    count = Product.where(seller: current_seller).count;
    max_updated_at = Product.where(seller: current_seller).maximum(:updated_at).try(:utc).try(:to_s, :number)
    "products/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_product(prod)
    "product/#{prod.id}/#{prod.updated_at}"
  end

end
