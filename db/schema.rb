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

ActiveRecord::Schema.define(version: 20180109204159) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coin_exchanges", force: :cascade do |t|
    t.integer "coin_id"
    t.integer "exchange_id"
    t.string  "url"
    t.integer "volume_24h"
    t.index ["coin_id"], name: "index_coin_exchanges_on_coin_id", using: :btree
    t.index ["exchange_id"], name: "index_coin_exchanges_on_exchange_id", using: :btree
  end

  create_table "coins", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_coins_on_key", using: :btree
  end

  create_table "exchanges", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_exchanges_on_key", using: :btree
  end

  create_table "markets", force: :cascade do |t|
    t.integer "coin_exchange_id"
    t.integer "coin_id"
    t.string  "url"
    t.integer "volume_24h"
    t.index ["coin_exchange_id"], name: "index_markets_on_coin_exchange_id", using: :btree
    t.index ["coin_id"], name: "index_markets_on_coin_id", using: :btree
  end

end
