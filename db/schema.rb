# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150624082744) do

  create_table "brands", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "logo_url",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "product_carousel_images", force: :cascade do |t|
    t.integer  "product_view_id", limit: 4
    t.integer  "position",        limit: 4
    t.text     "url",             limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "product_carousel_images", ["product_view_id"], name: "index_product_carousel_images_on_product_view_id", using: :btree

  create_table "product_detail_images", force: :cascade do |t|
    t.integer  "product_view_id", limit: 4
    t.integer  "position",        limit: 4
    t.text     "url",             limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "product_detail_images", ["product_view_id"], name: "index_product_detail_images_on_product_view_id", using: :btree

  create_table "product_sale_schedules", force: :cascade do |t|
    t.integer  "product_id",    limit: 4
    t.datetime "sale_start"
    t.datetime "sale_end"
    t.datetime "trailer_start"
    t.datetime "trailer_end"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "product_sale_schedules", ["product_id"], name: "index_product_sale_schedules_on_product_id", using: :btree

  create_table "product_views", force: :cascade do |t|
    t.integer  "product_id",              limit: 4
    t.string   "home_page_description",   limit: 255
    t.text     "detail_page_description", limit: 65535
    t.integer  "sale_image_type",         limit: 4
    t.text     "sale_image_url",          limit: 65535
    t.text     "trailer_image_url",       limit: 65535
    t.string   "trailer_description",     limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "product_views", ["product_id"], name: "index_product_views_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "brand_id",       limit: 4
    t.decimal  "price",                      precision: 10, scale: 2
    t.decimal  "original_price",             precision: 10, scale: 2
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "product_carousel_images", "product_views"
  add_foreign_key "product_detail_images", "product_views"
  add_foreign_key "product_sale_schedules", "products"
  add_foreign_key "product_views", "products"
  add_foreign_key "products", "brands"
end
