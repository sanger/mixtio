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

ActiveRecord::Schema.define(version: 20150811104826) do

  create_table "reagent_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reagents", force: :cascade do |t|
    t.integer  "reagent_type_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.string   "barcode"
    t.date     "expiry_date"
    t.date     "arrival_date"
    t.boolean  "depleted",        default: false
    t.string   "lot_number"
    t.string   "supplier"
  end

  add_index "reagents", ["reagent_type_id"], name: "index_reagents_on_reagent_type_id"

end
