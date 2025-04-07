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

ActiveRecord::Schema[7.0].define(version: 2025_04_03_171133) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "name"
    t.string "party"
    t.string "office"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenge_participants", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "challenge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_participants_on_challenge_id"
    t.index ["user_id"], name: "index_challenge_participants_on_user_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "criteria_for_winning"
    t.string "prize"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "judging_method"
    t.string "prize_type", default: "tokens"
    t.integer "token_prize_percentage", default: 75
    t.integer "fixed_token_prize"
    t.integer "product_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "finals_judging"
    t.integer "entry_fee", default: 0
    t.index ["creator_id"], name: "index_challenges_on_creator_id"
  end

  create_table "chats", force: :cascade do |t|
    t.integer "user1_id", null: false
    t.integer "user2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id", "user2_id"], name: "index_chats_on_user1_id_and_user2_id", unique: true
    t.index ["user1_id"], name: "index_chats_on_user1_id"
    t.index ["user2_id"], name: "index_chats_on_user2_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.integer "wonk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profile_id"
    t.integer "parent_comment_id"
    t.integer "replies_count", default: 0, null: false
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "criterions", force: :cascade do |t|
    t.string "name"
    t.integer "max_score"
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_criterions_on_challenge_id"
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "challenge_participant_id", null: false
    t.string "title"
    t.text "description"
    t.string "status", default: "draft"
    t.integer "score"
    t.datetime "published_at"
    t.string "visibility", default: "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_participant_id"], name: "index_entries_on_challenge_participant_id"
  end

  create_table "favorite_judges", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_favorite_judges_on_profile_id"
    t.index ["user_id"], name: "index_favorite_judges_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "judgeships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_judgeships_on_challenge_id"
    t.index ["user_id", "challenge_id"], name: "index_judgeships_on_user_id_and_challenge_id", unique: true
    t.index ["user_id"], name: "index_judgeships_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profile_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.text "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "message"
    t.string "link"
    t.integer "from_user_id"
    t.index ["from_user_id"], name: "index_notifications_on_from_user_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "photo"
    t.string "first_name"
    t.string "last_name"
    t.string "user_name"
    t.date "date_of_birth"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.text "interests"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_judge", default: false
    t.string "category"
    t.text "bio"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "scores", force: :cascade do |t|
    t.decimal "value"
    t.bigint "entry_id", null: false
    t.bigint "criterion_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["criterion_id"], name: "index_scores_on_criterion_id"
    t.index ["entry_id"], name: "index_scores_on_entry_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.decimal "value", precision: 10
    t.bigint "user_id", null: false
    t.datetime "expires_at"
    t.boolean "revoked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "wallet_id", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
    t.index ["wallet_id"], name: "index_tokens_on_wallet_id"
  end

  create_table "user_candidates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["candidate_id"], name: "index_user_candidates_on_candidate_id"
    t.index ["user_id"], name: "index_user_candidates_on_user_id"
  end

  create_table "user_issues", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_user_issues_on_issue_id"
    t.index ["user_id"], name: "index_user_issues_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "role", default: "user"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "entry_id", null: false
    t.integer "weight", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "challenge_id", null: false
    t.index ["challenge_id"], name: "index_votes_on_challenge_id"
    t.index ["entry_id"], name: "index_votes_on_entry_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "wonks", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0, null: false
    t.bigint "challenge_id"
    t.string "wonk_type", default: "profile"
    t.index ["challenge_id"], name: "index_wonks_on_challenge_id"
    t.index ["profile_id"], name: "index_wonks_on_profile_id"
    t.index ["user_id"], name: "index_wonks_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaigns", "users"
  add_foreign_key "challenge_participants", "challenges"
  add_foreign_key "challenge_participants", "users"
  add_foreign_key "challenges", "users", column: "creator_id"
  add_foreign_key "comments", "comments", column: "parent_comment_id"
  add_foreign_key "comments", "users"
  add_foreign_key "criterions", "challenges"
  add_foreign_key "entries", "challenge_participants"
  add_foreign_key "favorite_judges", "profiles"
  add_foreign_key "favorite_judges", "users"
  add_foreign_key "judgeships", "challenges"
  add_foreign_key "judgeships", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "scores", "criterions"
  add_foreign_key "scores", "entries"
  add_foreign_key "scores", "users"
  add_foreign_key "tokens", "users"
  add_foreign_key "tokens", "wallets"
  add_foreign_key "user_candidates", "candidates"
  add_foreign_key "user_candidates", "users"
  add_foreign_key "user_issues", "issues"
  add_foreign_key "user_issues", "users"
  add_foreign_key "votes", "challenges"
  add_foreign_key "votes", "entries"
  add_foreign_key "votes", "users"
  add_foreign_key "wallets", "users"
  add_foreign_key "wonks", "challenges"
  add_foreign_key "wonks", "profiles"
  add_foreign_key "wonks", "users"
end
