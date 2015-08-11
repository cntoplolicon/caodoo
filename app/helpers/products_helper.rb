module ProductsHelper
  def products_signature
    keys = [Product.count, Product.maximum(:updated_at).utc.iso8601,
            Brand.count, Brand.maximum(:updated_at).utc.iso8601,
            ProductGroup.count, ProductGroup.maximum(:updated_at).utc.iso8601,
            Time.now.utc.change(sec: 0).iso8601]
    Digest::MD5.hexdigest(keys.join)
  end

  def cache_key_for_on_sale_products
    "products/onsale-#{products_signature}"
  end

  def cache_key_for_upcoming_products
    "products/upcoming-#{products_signature}"
  end
end
