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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121002011005) do

  create_table "members", :force => true do |t|
    t.string   "name1"
    t.string   "name2"
    t.string   "name3"
    t.string   "email",                                     :null => false
    t.boolean  "admin",                  :default => false, :null => false
    t.string   "password_salt",                             :null => false
    t.string   "persistence_token",                         :null => false
    t.string   "perishable_token",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "phone"
    t.text     "extra_emails"
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "disabled",               :default => false
    t.text     "disabled_reason"
  end

  add_index "members", ["email"], :name => "index_members_on_email"
  add_index "members", ["persistence_token"], :name => "index_members_on_persistence_token"

  create_table "order_details", :force => true do |t|
    t.integer  "order_id"
    t.decimal  "quantity"
    t.integer  "stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "archived_supplier"
    t.integer  "archived_product"
    t.string   "archived_name"
    t.decimal  "archived_cost",         :precision => 10, :scale => 2
    t.decimal  "archived_markup_pct",   :precision => 10, :scale => 2
    t.decimal  "archived_markup_const", :precision => 10, :scale => 2
  end

  create_table "orders", :force => true do |t|
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "taken",            :default => false, :null => false
    t.boolean  "paid",             :default => false, :null => false
    t.datetime "taken_at"
    t.datetime "paid_at"
    t.integer  "marked_paid_by"
    t.boolean  "archived",         :default => false, :null => false
    t.boolean  "paid_with_paypal", :default => false, :null => false
    t.datetime "pickup_on"
    t.text     "notes"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "units"
    t.string   "category"
    t.decimal  "density_g_per_ml",  :precision => 12, :scale => 6
    t.decimal  "servings_per_unit", :precision => 10, :scale => 2
  end

  create_table "services", :force => true do |t|
    t.integer  "member_id"
    t.decimal  "hours"
    t.string   "task"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observed_by"
    t.datetime "did_at"
  end

  create_table "settings", :force => true do |t|
    t.decimal  "sales_tax"
    t.decimal  "global_markup_percent"
    t.decimal  "paypal_fee_percent"
    t.decimal  "paypal_fee_per"
    t.string   "pickup_dows"
    t.decimal  "workshare_hours_per_month"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "num_months_under_disable",  :default => 3
    t.decimal  "annual_fee",                :default => 100.0
  end

  create_table "stocks", :force => true do |t|
    t.string   "name"
    t.decimal  "quantity"
    t.decimal  "cost"
    t.string   "origin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id"
    t.integer  "product_id"
    t.decimal  "markup_pct",   :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "markup_const", :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.boolean  "limited",                                     :default => false, :null => false
  end

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
