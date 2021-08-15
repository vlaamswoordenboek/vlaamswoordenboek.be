# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_15_114011) do

  create_table "comments", id: :integer, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id"
    t.datetime "created_at"
    t.integer "resource_id"
    t.string "resource_type"
  end

  create_table "definition_versions", id: :integer, force: :cascade do |t|
    t.integer "definition_id"
    t.integer "version"
    t.binary "word"
    t.text "description", collation: "utf8mb4_0900_ai_ci"
    t.text "example", collation: "utf8mb4_0900_ai_ci"
    t.integer "positivevotes", default: 0
    t.integer "negativevotes", default: 0
    t.integer "updated_by"
    t.datetime "updated_at"
    t.integer "regio", default: 0
    t.integer "rating"
    t.string "properties", default: "", null: false
  end

  create_table "definitions", id: :integer, force: :cascade do |t|
    t.string "word", collation: "utf8mb4_0900_ai_ci"
    t.text "description", collation: "utf8mb4_0900_ai_ci"
    t.text "example", collation: "utf8mb4_0900_ai_ci"
    t.integer "positivevotes", default: 0, null: false
    t.integer "negativevotes", default: 0, null: false
    t.integer "updated_by"
    t.datetime "updated_at"
    t.integer "regio", default: 0
    t.integer "version"
    t.integer "rating"
    t.string "properties", default: "", null: false
    t.bigint "created_by_id"
    t.bigint "last_edited_by_id"
    t.index ["created_by_id"], name: "index_definitions_on_created_by_id"
    t.index ["last_edited_by_id"], name: "index_definitions_on_last_edited_by_id"
  end

  create_table "forums", id: :integer, force: :cascade do |t|
    t.string "title"
    t.text "body"
  end

  create_table "forumtopics", id: :integer, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id"
    t.datetime "created_at"
    t.integer "forum_id"
  end

  create_table "globalize_countries", id: :integer, force: :cascade do |t|
    t.string "code", limit: 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code", limit: 3
    t.string "thousands_sep", limit: 2
    t.string "decimal_sep", limit: 2
    t.string "currency_decimal_sep", limit: 2
    t.string "number_grouping_scheme"
    t.index ["code"], name: "index_globalize_countries_on_code"
  end

  create_table "globalize_languages", id: :integer, force: :cascade do |t|
    t.string "iso_639_1", limit: 2
    t.string "iso_639_2", limit: 3
    t.string "iso_639_3", limit: 3
    t.string "rfc_3066"
    t.string "english_name"
    t.string "english_name_locale"
    t.string "english_name_modifier"
    t.string "native_name"
    t.string "native_name_locale"
    t.string "native_name_modifier"
    t.boolean "macro_language"
    t.string "direction"
    t.string "pluralization"
    t.string "scope", limit: 1
    t.index ["iso_639_1"], name: "index_globalize_languages_on_iso_639_1"
    t.index ["iso_639_2"], name: "index_globalize_languages_on_iso_639_2"
    t.index ["iso_639_3"], name: "index_globalize_languages_on_iso_639_3"
    t.index ["rfc_3066"], name: "index_globalize_languages_on_rfc_3066"
  end

  create_table "globalize_translations", id: :integer, force: :cascade do |t|
    t.string "type"
    t.string "tr_key"
    t.string "table_name"
    t.integer "item_id"
    t.string "facet"
    t.boolean "built_in", default: true
    t.integer "language_id"
    t.integer "pluralization_index"
    t.text "text"
    t.string "namespace"
    t.index ["table_name", "item_id", "language_id"], name: "globalize_translations_table_name_and_item_and_language"
    t.index ["tr_key", "language_id"], name: "index_globalize_translations_on_tr_key_and_language_id"
  end

  create_table "messages", id: :integer, force: :cascade do |t|
    t.integer "from_user"
    t.integer "to_user"
    t.string "title", collation: "utf8mb4_0900_ai_ci"
    t.text "body", collation: "utf8mb4_0900_ai_ci"
    t.datetime "created_at"
    t.boolean "read", default: false, null: false
  end

  create_table "reactions", id: :integer, force: :cascade do |t|
    t.string "title", collation: "utf8mb4_0900_ai_ci"
    t.text "body", collation: "utf8mb4_0900_ai_ci"
    t.integer "definition_id"
    t.integer "created_by"
    t.datetime "created_at"
  end

  create_table "schema_info", id: false, force: :cascade do |t|
    t.integer "version"
  end

  create_table "users", id: :integer, force: :cascade do |t|
    t.string "login"
    t.string "email"
    t.string "crypted_password", limit: 40
    t.string "salt", limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.text "details"
  end

  create_table "voters", id: :integer, force: :cascade do |t|
  end

  create_table "votes", id: :integer, force: :cascade do |t|
    t.integer "voter_id"
    t.integer "definition_id"
    t.integer "value"
  end

  create_table "wotds", id: :integer, force: :cascade do |t|
    t.integer "definition_id"
    t.date "date"
  end

end
