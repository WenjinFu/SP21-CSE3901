# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_17_232551) do

  create_table "admins", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "evaluation_questions", force: :cascade do |t|
    t.integer "evaluation_id", null: false
    t.integer "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["evaluation_id"], name: "index_evaluation_questions_on_evaluation_id"
    t.index ["question_id"], name: "index_evaluation_questions_on_question_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.string "name"
    t.datetime "due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.text "prompt_text"
    t.integer "class_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "section_users", force: :cascade do |t|
    t.integer "section_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_section_users_on_section_id"
    t.index ["user_id"], name: "index_section_users_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_id"
  end

  create_table "team_users", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_team_users_on_team_id"
    t.index ["user_id"], name: "index_team_users_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "class_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_evaluation_question_scores", force: :cascade do |t|
    t.integer "user_evaluation_id"
    t.integer "numerical_score"
    t.text "answer_text"
    t.integer "evaluation_question_id"
    t.boolean "is_completed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_evaluations", force: :cascade do |t|
    t.integer "reviewer_id"
    t.integer "reviewee_id"
    t.integer "team_id"
    t.integer "evaluation_id"
    t.boolean "is_completed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.boolean "is_pw_set"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "evaluation_questions", "evaluations"
  add_foreign_key "evaluation_questions", "questions"
  add_foreign_key "section_users", "sections"
  add_foreign_key "section_users", "users"
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "users"
end
