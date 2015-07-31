p = Product.create(brand_id: 1, name: '健康助手', price: 100, original_price: 200, priority: 0, quantity: 100)
p.create_product_view(home_page_description: '主页文案', detail_page_description: '详细页文案详细页文案', sale_image_type: 1, sale_image_url: 'development/sale1.png', trailer_image_url: 'development/trailer.png', trailer_description: '预告文案')
(0..3).each do |i|
  p.product_view.product_carousel_images.create(position: i, url: "development/carousel/#{i + 1}.jpg")
end
(0..3).each do |i|
  p.product_view.product_detail_images.create(position: i, url: "development/detail/#{i + 1}.jpg")
end
p.product_sale_schedules.create(sale_start: Time.zone.now, sale_end: Time.zone.now + 20.days, trailer_start: Time.zone.now, trailer_end: Time.zone.now)
