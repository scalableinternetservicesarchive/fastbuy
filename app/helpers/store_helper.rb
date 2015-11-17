module StoreHelper

  def cache_key_for_products
    count = Product.count
    max_updated_at = Product.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "products/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_product(prod)
    "product/#{prod.id}/#{prod.updated_at}/#{prod.sale_products.count}"
  end

end
