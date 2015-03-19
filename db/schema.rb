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

ActiveRecord::Schema.define(version: 20150319142211) do

  create_table "albums", force: true do |t|
    t.string   "title"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "representative_picture"
    t.integer  "album_id"
    t.string   "area"
    t.integer  "place_id"
    t.string   "description"
    t.string   "detail"
  end

  create_table "areas", force: true do |t|
    t.string   "area"
    t.string   "ja"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "date"
    t.string   "url"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "title"
    t.integer  "album_id"
    t.string   "description"
  end

  create_table "scenecounts", force: true do |t|
    t.string   "text"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scenes", force: true do |t|
    t.integer  "picture_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "score"
    t.integer  "album_id"
  end

  create_table "tagcounts", force: true do |t|
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text"
  end

  create_table "tags", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "picture_id"
    t.string   "text"
    t.integer  "album_id"
  end

end
