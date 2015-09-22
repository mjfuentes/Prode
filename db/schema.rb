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

ActiveRecord::Schema.define(version: 20150922133147) do

  create_table "activity", force: :cascade do |t|
    t.integer "version", limit: 8, null: false
  end

  create_table "author", force: :cascade do |t|
    t.integer "version",    limit: 8,   null: false
    t.integer "age",        limit: 4,   null: false
    t.string  "last_name",  limit: 255, null: false
    t.string  "name",       limit: 255, null: false
    t.string  "profession", limit: 255, null: false
  end

  create_table "category", force: :cascade do |t|
    t.integer "version",     limit: 8,   null: false
    t.string  "description", limit: 255, null: false
    t.string  "name",        limit: 255, null: false
  end

  add_index "category", ["name"], name: "UK_46ccwnsi9409t36lurvtyljak", unique: true, using: :btree

  create_table "drink", force: :cascade do |t|
    t.integer "version",  limit: 8,   null: false
    t.integer "image_id", limit: 8
    t.string  "name",     limit: 255, null: false
  end

  add_index "drink", ["image_id"], name: "FK_h4ere0ygvgtqs6hcbhu8o9ct1", using: :btree
  add_index "drink", ["name"], name: "UK_gf07vui7f23acsy3j161804ej", unique: true, using: :btree

  create_table "facebook_user", force: :cascade do |t|
    t.integer  "version",              limit: 8,   null: false
    t.string   "access_token",         limit: 255, null: false
    t.datetime "access_token_expires",             null: false
    t.integer  "uid",                  limit: 8,   null: false
    t.integer  "user_id",              limit: 8,   null: false
  end

  add_index "facebook_user", ["uid"], name: "UK_hpsfj02fd97v1meiohsmyqqww", unique: true, using: :btree
  add_index "facebook_user", ["user_id"], name: "FK_jn890f8vojymgn9tf3jhj2jum", using: :btree

  create_table "forgot_password", force: :cascade do |t|
    t.integer  "version",             limit: 8,   null: false
    t.integer  "back_office_user_id", limit: 8
    t.datetime "expiration_time",                 null: false
    t.datetime "expired_time"
    t.binary   "is_expired",          limit: 1,   null: false
    t.binary   "password_changed",    limit: 1
    t.string   "tokenfp",             limit: 255, null: false
  end

  add_index "forgot_password", ["back_office_user_id"], name: "FK_9dppencxxv6h75hfsytaj8iao", using: :btree

  create_table "guesses", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "match_id",   limit: 4
    t.integer  "home_score", limit: 4
    t.integer  "away_score", limit: 4
    t.integer  "points",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "ingredient", force: :cascade do |t|
    t.integer "version",  limit: 8,   null: false
    t.integer "image_id", limit: 8
    t.string  "name",     limit: 255, null: false
  end

  add_index "ingredient", ["image_id"], name: "FK_2rhr2o5s8jnx1551s6g17vo27", using: :btree
  add_index "ingredient", ["name"], name: "UK_bcuaj97y3iu3t2vj26jg6hijj", unique: true, using: :btree

  create_table "matchdays", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "finished",   limit: 1
    t.boolean  "started",    limit: 1
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "home_team_id", limit: 4
    t.integer  "away_team_id", limit: 4
    t.integer  "home_score",   limit: 4
    t.integer  "away_score",   limit: 4
    t.boolean  "finished",     limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "matchday_id",  limit: 4
  end

  create_table "password_change", force: :cascade do |t|
    t.integer  "version",     limit: 8,   null: false
    t.datetime "change_date",             null: false
    t.string   "password",    limit: 255, null: false
    t.integer  "user_id",     limit: 8,   null: false
  end

  add_index "password_change", ["user_id"], name: "FK_t49vswricmyy3vs9ax042fgil", using: :btree

  create_table "recipe", force: :cascade do |t|
    t.integer  "version",       limit: 8,   null: false
    t.integer  "author_id",     limit: 8,   null: false
    t.integer  "category_id",   limit: 8,   null: false
    t.datetime "creation_date",             null: false
    t.integer  "drink_id",      limit: 8,   null: false
    t.binary   "enabled",       limit: 1,   null: false
    t.string   "name",          limit: 255, null: false
    t.string   "video_url",     limit: 255
  end

  add_index "recipe", ["author_id"], name: "FK_kefnamg0lrq0axhwwm7olf76u", using: :btree
  add_index "recipe", ["category_id"], name: "FK_50i8awntdgrmfqmw48o74j38t", using: :btree
  add_index "recipe", ["drink_id"], name: "FK_6hjil5c6ldurf1n0lq2cwiybc", using: :btree
  add_index "recipe", ["name"], name: "UK_rm1mlratj8yf3e1yxwk156x4p", unique: true, using: :btree

  create_table "recipient", force: :cascade do |t|
    t.integer "version",  limit: 8,   null: false
    t.integer "image_id", limit: 8
    t.string  "name",     limit: 255, null: false
  end

  add_index "recipient", ["image_id"], name: "FK_7bbfkltjuxwh1kuv9h2c1kvtd", using: :btree

  create_table "requestmap", force: :cascade do |t|
    t.integer "version",          limit: 8,   null: false
    t.string  "config_attribute", limit: 255, null: false
    t.string  "http_method",      limit: 255
    t.string  "url",              limit: 255, null: false
  end

  add_index "requestmap", ["http_method", "url"], name: "unique_url", unique: true, using: :btree

  create_table "role", force: :cascade do |t|
    t.integer "version",   limit: 8,   null: false
    t.string  "authority", limit: 255, null: false
  end

  add_index "role", ["authority"], name: "UK_irsamgnera6angm0prq1kemt2", unique: true, using: :btree

  create_table "step", force: :cascade do |t|
    t.integer "version",      limit: 8,   null: false
    t.integer "activity_id",  limit: 8,   null: false
    t.string  "description",  limit: 255, null: false
    t.float   "duration",     limit: 53,  null: false
    t.float   "proportion",   limit: 53,  null: false
    t.integer "recipe_id",    limit: 8,   null: false
    t.integer "recipient_id", limit: 8,   null: false
  end

  add_index "step", ["activity_id"], name: "FK_rxdlqpl01e7ryn3nr4nv083q0", using: :btree
  add_index "step", ["recipe_id"], name: "FK_bclpmti9g9mco7cua4yvus0q0", using: :btree
  add_index "step", ["recipient_id"], name: "FK_bl5m3xpn4up5lxtul00kh1i5e", using: :btree

  create_table "step_ingredient", id: false, force: :cascade do |t|
    t.integer "step_ingredients_id", limit: 8
    t.integer "ingredient_id",       limit: 8
  end

  add_index "step_ingredient", ["ingredient_id"], name: "FK_mfnarfw66lass2t3y4d9xnqyl", using: :btree
  add_index "step_ingredient", ["step_ingredients_id"], name: "FK_lpge2qbtt6xly2grp0muby4xt", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user", force: :cascade do |t|
    t.integer  "version",                 limit: 8,   null: false
    t.binary   "account_expired",         limit: 1,   null: false
    t.binary   "account_locked",          limit: 1,   null: false
    t.datetime "date_created",                        null: false
    t.string   "email",                   limit: 255, null: false
    t.binary   "enabled",                 limit: 1,   null: false
    t.string   "password",                limit: 255, null: false
    t.binary   "password_expired",        limit: 1,   null: false
    t.string   "username",                limit: 50,  null: false
    t.string   "class",                   limit: 255, null: false
    t.string   "last_name",               limit: 50
    t.string   "name",                    limit: 50
    t.string   "profile_picture",         limit: 255
    t.binary   "profile_picture_enabled", limit: 1
  end

  add_index "user", ["email"], name: "UK_ob8kqyqqgmefl0aco34akdtpe", unique: true, using: :btree
  add_index "user", ["username"], name: "UK_sb8bbouer5wak8vyiiy4pf2bx", unique: true, using: :btree

  create_table "user_role", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 8, null: false
    t.integer "user_id", limit: 8, null: false
  end

  add_index "user_role", ["user_id"], name: "FK_apcc8lxk2xnug8377fatvbn04", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "admin",                  limit: 1
    t.string   "name",                   limit: 255
    t.integer  "facebookid",             limit: 8
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  add_foreign_key "drink", "image", name: "FK_h4ere0ygvgtqs6hcbhu8o9ct1"
  add_foreign_key "facebook_user", "user", name: "FK_jn890f8vojymgn9tf3jhj2jum"
  add_foreign_key "forgot_password", "user", column: "back_office_user_id", name: "FK_9dppencxxv6h75hfsytaj8iao"
  add_foreign_key "ingredient", "image", name: "FK_2rhr2o5s8jnx1551s6g17vo27"
  add_foreign_key "password_change", "user", name: "FK_t49vswricmyy3vs9ax042fgil"
  add_foreign_key "recipe", "author", name: "FK_kefnamg0lrq0axhwwm7olf76u"
  add_foreign_key "recipe", "category", name: "FK_50i8awntdgrmfqmw48o74j38t"
  add_foreign_key "recipe", "drink", name: "FK_6hjil5c6ldurf1n0lq2cwiybc"
  add_foreign_key "recipient", "image", name: "FK_7bbfkltjuxwh1kuv9h2c1kvtd"
  add_foreign_key "step", "activity", name: "FK_rxdlqpl01e7ryn3nr4nv083q0"
  add_foreign_key "step", "recipe", name: "FK_bclpmti9g9mco7cua4yvus0q0"
  add_foreign_key "step", "recipient", name: "FK_bl5m3xpn4up5lxtul00kh1i5e"
  add_foreign_key "step_ingredient", "ingredient", name: "FK_mfnarfw66lass2t3y4d9xnqyl"
  add_foreign_key "step_ingredient", "step", column: "step_ingredients_id", name: "FK_lpge2qbtt6xly2grp0muby4xt"
  add_foreign_key "user_role", "role", name: "FK_it77eq964jhfqtu54081ebtio"
  add_foreign_key "user_role", "user", name: "FK_apcc8lxk2xnug8377fatvbn04"
end
