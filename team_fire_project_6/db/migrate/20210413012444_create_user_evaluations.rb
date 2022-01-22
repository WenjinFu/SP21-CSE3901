class CreateUserEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_evaluations do |t|
      t.integer :reviewer_id
      t.integer :reviewee_id
      t.integer :team_id
      t.integer :evaluation_id
      t.boolean :is_completed

      t.timestamps
    end
  end
end
