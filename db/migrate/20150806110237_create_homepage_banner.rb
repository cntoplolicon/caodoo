class CreateHomepageBanner < ActiveRecord::Migration
  def change
    create_table :homepage_banners do |t|
      t.text :pc_image_url
      t.text :mobile_image_url
      t.text :link_url
      t.string :description
      t.integer :priority
    end
  end
end