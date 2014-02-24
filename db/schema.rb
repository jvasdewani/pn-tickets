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

ActiveRecord::Schema.define(version: 20140207124239) do

  create_table "assignments", force: true do |t|
    t.integer  "person_id"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["department_id"], name: "index_assignments_on_department_id", using: :btree
  add_index "assignments", ["person_id"], name: "index_assignments_on_person_id", using: :btree

  create_table "branches", force: true do |t|
    t.integer  "client_id"
    t.string   "branch_name"
    t.string   "contact_phone"
    t.string   "contact_phone_ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["client_id"], name: "index_branches_on_client_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "company"
    t.date     "health_check_date"
    t.integer  "health_check_department_id"
    t.integer  "health_check_person_id"
    t.string   "wiki_page"
    t.string   "group"
    t.boolean  "active_client"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_phone"
    t.string   "contact_phone_ext"
  end

  add_index "clients", ["health_check_department_id"], name: "index_clients_on_health_check_department_id", using: :btree
  add_index "clients", ["health_check_person_id"], name: "index_clients_on_health_check_person_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "issue_id"
    t.integer  "person_id"
    t.text     "content"
    t.string   "_pp"
    t.string   "_np"
    t.string   "_ps"
    t.string   "_ns"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment"
  end

  add_index "comments", ["issue_id"], name: "index_comments_on_issue_id", using: :btree
  add_index "comments", ["person_id"], name: "index_comments_on_person_id", using: :btree

  create_table "contacts", force: true do |t|
    t.integer  "branch_id"
    t.string   "forename"
    t.string   "surname"
    t.string   "email"
    t.string   "contact_phone"
    t.string   "contact_phone_ext"
    t.string   "contact_mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["branch_id"], name: "index_contacts_on_branch_id", using: :btree

  create_table "contracts", force: true do |t|
    t.integer  "client_id"
    t.string   "contract_name"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "value"
    t.string   "renewal_type"
    t.integer  "service_time_allocation"
    t.integer  "service_time_used"
    t.boolean  "invoiced"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "direct_debit"
  end

  add_index "contracts", ["client_id"], name: "index_contracts_on_client_id", using: :btree

  create_table "departments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "department_name"
    t.text     "notify_list"
  end

  create_table "issues", force: true do |t|
    t.string   "subject"
    t.integer  "issue_time_cache"
    t.integer  "response_time_cache"
    t.string   "status"
    t.string   "priority"
    t.string   "checkid"
    t.boolean  "checkcleared"
    t.string   "checkstarttime"
    t.string   "checkstartdate"
    t.text     "checkdescription"
    t.integer  "product_type_id"
    t.integer  "checklist_id"
    t.integer  "closed_by_id"
    t.integer  "person_id"
    t.integer  "department_id"
    t.integer  "client_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["checklist_id"], name: "index_issues_on_checklist_id", using: :btree
  add_index "issues", ["client_id"], name: "index_issues_on_client_id", using: :btree
  add_index "issues", ["closed_by_id"], name: "index_issues_on_closed_by_id", using: :btree
  add_index "issues", ["contact_id"], name: "index_issues_on_contact_id", using: :btree
  add_index "issues", ["department_id"], name: "index_issues_on_department_id", using: :btree
  add_index "issues", ["person_id"], name: "index_issues_on_person_id", using: :btree
  add_index "issues", ["product_type_id"], name: "index_issues_on_product_type_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "contract_id"
    t.date     "due_at"
    t.date     "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["contract_id"], name: "index_payments_on_contract_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "password_salt"
    t.string   "forename"
    t.string   "surname"
    t.string   "email"
    t.boolean  "admin"
    t.boolean  "manager"
    t.boolean  "tickets"
    t.boolean  "reports"
    t.boolean  "contracts"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_scoreboard"
    t.boolean  "quotes"
  end

  add_index "people", ["department_id"], name: "index_people_on_department_id", using: :btree

  create_table "product_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", force: true do |t|
    t.text     "requirements"
    t.integer  "client_id"
    t.boolean  "approved"
    t.boolean  "goods_received"
    t.boolean  "payment_received"
    t.boolean  "payment_sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quotes", ["client_id"], name: "index_quotes_on_client_id", using: :btree

  create_table "reminder_categories", force: true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminders", force: true do |t|
    t.integer  "client_id"
    t.integer  "reminder_category_id"
    t.string   "description"
    t.date     "end_date"
    t.float    "value"
    t.boolean  "paid"
    t.boolean  "invoiced"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_assignments", force: true do |t|
    t.integer  "contract_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_assignments", ["contract_id"], name: "index_service_assignments_on_contract_id", using: :btree
  add_index "service_assignments", ["service_id"], name: "index_service_assignments_on_service_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplier_assignments", force: true do |t|
    t.integer  "supplier_quote_id"
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supplier_assignments", ["supplier_id"], name: "index_supplier_assignments_on_supplier_id", using: :btree
  add_index "supplier_assignments", ["supplier_quote_id"], name: "index_supplier_assignments_on_supplier_quote_id", using: :btree

  create_table "supplier_quotes", force: true do |t|
    t.integer  "quote_id"
    t.text     "description"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supplier_quotes", ["quote_id"], name: "index_supplier_quotes_on_quote_id", using: :btree

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_lists", force: true do |t|
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_lists", ["department_id"], name: "index_task_lists_on_department_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "task_name"
    t.integer  "task_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["task_list_id"], name: "index_tasks_on_task_list_id", using: :btree

end
