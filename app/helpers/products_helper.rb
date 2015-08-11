module ProductsHelper
  def products_signature
    Time.now.utc.change(sec: 0).iso8601
  end

  def cache_key_for_on_sale_products
    "products/onsale-#{products_signature}"
  end

  def cache_key_for_upcoming_products
    "products/upcoming-#{products_signature}"
  end
end
