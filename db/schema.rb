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

ActiveRecord::Schema.define(version: 20150718034822) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "receiver",         limit: 255
    t.string   "phone",            limit: 255
    t.string   "province_code",    limit: 255
    t.string   "city_code",        limit: 255
    t.string   "district_code",    limit: 255
    t.text     "detailed_address", limit: 65535
    t.boolean  "default",          limit: 1,     default: false
    t.boolean  "deleted",          limit: 1,     default: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "logo_url",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "contest_page_views", force: :cascade do |t|
    t.integer  "contest_team_id", limit: 4
    t.string   "request_ip",      limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "contest_teams", force: :cascade do |t|
    t.string   "identifier",       limit: 48
    t.string   "name",             limit: 48
    t.string   "password_digest",  limit: 255
    t.string   "university",       limit: 48
    t.string   "area",             limit: 48
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "sales_quantity",   limit: 4,   default: 0
    t.boolean  "password_updated", limit: 1,   default: false
    t.string   "phone",            limit: 48
    t.string   "email",            limit: 255
    t.string   "province",         limit: 255
    t.string   "contacts",         limit: 255
  end

  add_index "contest_teams", ["area"], name: "index_contest_teams_on_area", using: :btree
  add_index "contest_teams", ["identifier"], name: "index_contest_teams_on_identifier", unique: true, using: :btree
  add_index "contest_teams", ["phone"], name: "index_contest_teams_on_phone", unique: true, using: :btree
  add_index "contest_teams", ["university"], name: "index_contest_teams_on_university", using: :btree

  create_table "expresses", force: :cascade do |t|
    t.string   "code",       limit: 32
    t.string   "name",       limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "deleted",    limit: 1,   default: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "order_number",      limit: 32
    t.integer  "user_id",           limit: 4
    t.integer  "product_id",        limit: 4
    t.string   "product_name",      limit: 255
    t.text     "product_image_url", limit: 65535
    t.decimal  "unit_price",                      precision: 10, scale: 2
    t.integer  "quantity",          limit: 4
    t.decimal  "total_price",                     precision: 10, scale: 2
    t.string   "receiver",          limit: 255
    t.string   "phone",             limit: 255
    t.string   "detailed_address",  limit: 255
    t.string   "province_code",     limit: 255
    t.string   "province_name",     limit: 255
    t.string   "city_code",         limit: 255
    t.string   "city_name",         limit: 255
    t.string   "district_code",     limit: 255
    t.string   "district_name",     limit: 255
    t.integer  "status",            limit: 4
    t.datetime "receive_time"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "address_id",        limit: 4
    t.integer  "contest_team_id",   limit: 4
    t.integer  "express_id",        limit: 4
    t.string   "tracking_number",   limit: 255
    t.boolean  "delivery_exported", limit: 1,                              default: false
  end

  add_index "orders", ["address_id"], name: "index_orders_on_address_id", using: :btree
  add_index "orders", ["contest_team_id"], name: "index_orders_on_contest_team_id", using: :btree
  add_index "orders", ["express_id"], name: "index_orders_on_express_id", using: :btree
  add_index "orders", ["order_number"], name: "index_orders_on_order_number", unique: true, using: :btree
  add_index "orders", ["product_id"], name: "index_orders_on_product_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_records", force: :cascade do |t|
    t.integer  "order_id",      limit: 4
    t.integer  "payment_type",  limit: 4
    t.decimal  "amount",                      precision: 10, scale: 2
    t.datetime "payment_time"
    t.integer  "status",        limit: 4
    t.string   "alipay_expire", limit: 255
    t.text     "wx_code_url",   limit: 65535
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "payment_records", ["order_id"], name: "index_payment_records_on_order_id", using: :btree

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
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "priority",       limit: 4,                            default: 0
    t.integer  "quantity",       limit: 4,                            default: 0
    t.integer  "contest_level",  limit: 4
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree

  create_table "refund_records", force: :cascade do |t|
    t.integer  "order_id",        limit: 4
    t.integer  "express_id",      limit: 4
    t.string   "tracking_number", limit: 255
    t.integer  "status",          limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "remark",          limit: 255
    t.integer  "quantity",        limit: 4
  end

  add_index "refund_records", ["express_id"], name: "index_refund_records_on_express_id", using: :btree
  add_index "refund_records", ["order_id"], name: "index_refund_records_on_order_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.integer  "code",       limit: 4
    t.string   "name",       limit: 255
    t.string   "parent",     limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "disabled",   limit: 1,   default: false
  end

  add_index "regions", ["code"], name: "index_regions_on_code", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "contest_teams"
  add_foreign_key "orders", "expresses"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_records", "orders"
  add_foreign_key "product_carousel_images", "product_views"
  add_foreign_key "product_detail_images", "product_views"
  add_foreign_key "product_sale_schedules", "products"
  add_foreign_key "product_views", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "refund_records", "expresses"
  add_foreign_key "refund_records", "orders"
end
