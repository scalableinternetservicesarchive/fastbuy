json.array!(@sale_products) do |sale_product|
  json.extract! sale_product, :id, :product_id, :price, :quantity, :expire_time
  json.url sale_product_url(sale_product, format: :json)
end
