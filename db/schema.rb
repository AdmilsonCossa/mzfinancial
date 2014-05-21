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

ActiveRecord::Schema.define(version: 20140514182621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "number"
    t.decimal  "balance"
    t.integer  "holder_id"
    t.integer  "bank_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["bank_id"], name: "index_accounts_on_bank_id", using: :btree
  add_index "accounts", ["holder_id"], name: "index_accounts_on_holder_id", using: :btree

  create_table "accounts_payables", force: true do |t|
    t.integer  "participant_id"
    t.integer  "financial_category_id"
    t.integer  "expense_type_id"
    t.integer  "account_id"
    t.datetime "issue_date"
    t.datetime "due_date"
    t.decimal  "value"
    t.text     "description"
    t.string   "document_serie"
    t.string   "document_number"
    t.string   "term_state"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts_payables", ["account_id"], name: "index_accounts_payables_on_account_id", using: :btree
  add_index "accounts_payables", ["expense_type_id"], name: "index_accounts_payables_on_expense_type_id", using: :btree
  add_index "accounts_payables", ["financial_category_id"], name: "index_accounts_payables_on_financial_category_id", using: :btree
  add_index "accounts_payables", ["participant_id"], name: "index_accounts_payables_on_participant_id", using: :btree

  create_table "accounts_receivables", force: true do |t|
    t.integer  "participant_id"
    t.integer  "financial_category_id"
    t.integer  "expense_type_id"
    t.integer  "account_id"
    t.datetime "issue_date"
    t.datetime "due_date"
    t.decimal  "value"
    t.text     "description"
    t.string   "document_serie"
    t.string   "document_number"
    t.string   "term_state"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts_receivables", ["account_id"], name: "index_accounts_receivables_on_account_id", using: :btree
  add_index "accounts_receivables", ["expense_type_id"], name: "index_accounts_receivables_on_expense_type_id", using: :btree
  add_index "accounts_receivables", ["financial_category_id"], name: "index_accounts_receivables_on_financial_category_id", using: :btree
  add_index "accounts_receivables", ["participant_id"], name: "index_accounts_receivables_on_participant_id", using: :btree

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "banks", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banks", ["account_id"], name: "index_banks_on_account_id", using: :btree

  create_table "expense_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "financial_categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["account_id"], name: "index_participants_on_account_id", using: :btree

  create_table "transaction_orders", force: true do |t|
    t.float    "value"
    t.string   "description"
    t.string   "state"
    t.datetime "state_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "value"
    t.string   "description"
    t.integer  "account_id"
    t.integer  "transaction_order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree
  add_index "transactions", ["transaction_order_id"], name: "index_transactions_on_transaction_order_id", using: :btree

  create_table "transfers", force: true do |t|
    t.text     "description"
    t.integer  "origin_account_id"
    t.integer  "destination_account_id"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "state"
  end

  add_index "transfers", ["destination_account_id"], name: "index_transfers_on_destination_account_id", using: :btree
  add_index "transfers", ["origin_account_id"], name: "index_transfers_on_origin_account_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
