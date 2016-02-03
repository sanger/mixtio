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

ActiveRecord::Schema.define(version: 20151216153548) do

  create_table "ancestors", force: :cascade do |t|
    t.string   "family_name"
    t.integer  "family_id"
    t.string   "relation_type"
    t.integer  "relation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "ancestors", ["family_id", "relation_type", "relation_id"], name: "index_ancestors_on_family_id_and_relation_type_and_relation_id"

  create_table "batches", force: :cascade do |t|
    t.integer  "lot_id"
    t.date     "expiry_date"
    t.date     "arrival_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "batches", ["lot_id"], name: "index_batches_on_lot_id"

  create_table "consumable_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "days_to_keep"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "consumables", force: :cascade do |t|
    t.integer  "batch_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name"
    t.string   "barcode"
    t.boolean  "depleted",   default: false
  end

  add_index "consumables", ["batch_id"], name: "index_consumables_on_batch_id"

  create_table "lots", force: :cascade do |t|
    t.integer  "consumable_type_id"
    t.integer  "supplier_id"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "lots", ["consumable_type_id"], name: "index_lots_on_consumable_type_id"
  add_index "lots", ["supplier_id"], name: "index_lots_on_supplier_id"

  create_table "mixtures", force: :cascade do |t|
    t.integer  "lot_id"
    t.integer  "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mixtures", ["batch_id"], name: "index_mixtures_on_batch_id"
  add_index "mixtures", ["lot_id"], name: "index_mixtures_on_lot_id"

  create_table "recipe_ingredients", force: :cascade do |t|
    t.string   "consumable_type_id"
    t.string   "ingredient_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
  end

end
