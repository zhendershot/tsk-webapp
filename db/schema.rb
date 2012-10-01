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

ActiveRecord::Schema.define(:version => 20111109210612) do

  create_table "members", :force => true do |t|
    t.string   "name1"
    t.string   "name2"
    t.string   "name3"
    t.string   "email",                                 :null => false
    t.boolean  "active",             :default => true,  :null => false
    t.boolean  "admin",              :default => false, :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "phone"
    t.text     "extra_emails"
  end

  add_index "members", ["email"], :name => "index_members_on_email"
  add_index "members", ["last_request_at"], :name => "index_members_on_last_request_at"
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

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
