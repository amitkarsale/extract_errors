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

ActiveRecord::Schema.define(version: 20170220113040) do

  create_table "errors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text     "message",     limit: 65535
    t.datetime "occured_at"
    t.string   "case_number"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["message"], name: "index_errors_on_message", length: { message: 255 }, using: :btree
  end

  create_table "file_attachments", id: :string, limit: 18, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "caseid",                        limit: 18,         null: false
    t.boolean  "deleted"
    t.boolean  "deprecated"
    t.text     "description",                   limit: 4294967295
    t.string   "link_to_file",                  limit: 254
    t.string   "uuid",                          limit: 254
    t.string   "name",                          limit: 254
    t.boolean  "private"
    t.bigint   "size"
    t.string   "type",                          limit: 254
    t.datetime "createddate"
    t.datetime "lastmodifieddate"
    t.string   "created_by_sso_username",       limit: 254
    t.string   "created_by_email",              limit: 254
    t.string   "last_modified_by_sso_username", limit: 254
    t.string   "last_modified_by_email",        limit: 254
    t.string   "casenumber",                    limit: 254
    t.index ["caseid"], name: "caseid_idx", using: :btree
    t.index ["casenumber"], name: "casenumber_idx", using: :btree
    t.index ["created_by_sso_username"], name: "created_by_sso_usnerame_idx", using: :btree
    t.index ["createddate"], name: "createddate_idx", using: :btree
  end

end
