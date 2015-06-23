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

ActiveRecord::Schema.define(version: 20150622154137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "procurement_areas", force: :cascade do |t|
    t.string   "name",                     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.jsonb    "memberships", default: []
  end

  add_index "procurement_areas", ["memberships"], name: "index_procurement_areas_on_memberships", using: :gin

  create_table "rota_slots", force: :cascade do |t|
    t.integer  "shift_id",                        null: false
    t.uuid     "organisation_uid",                null: false
    t.integer  "procurement_area_id"
    t.datetime "starting_time"
    t.datetime "ending_time"
    t.integer  "request_count",       default: 0, null: false
    t.string   "solicitor_name"
  end

  add_index "rota_slots", ["procurement_area_id"], name: "index_rota_slots_on_procurement_area_id", using: :btree

  create_table "shifts", force: :cascade do |t|
    t.string   "name"
    t.string   "location_uid",                                     null: false
    t.time     "starting_time"
    t.time     "ending_time"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.jsonb    "allocation_requirements_per_weekday", default: {}
  end

  add_index "shifts", ["allocation_requirements_per_weekday"], name: "index_shifts_on_allocation_requirements_per_weekday", using: :gin
  add_index "shifts", ["location_uid"], name: "index_shifts_on_location_uid", using: :btree

  add_foreign_key "rota_slots", "procurement_areas", on_delete: :cascade
end
