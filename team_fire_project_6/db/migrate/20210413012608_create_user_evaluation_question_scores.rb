class CreateUserEvaluationQuestionScores < ActiveRecord::Migration[6.0]
  def change
    create_table :user_evaluation_question_scores do |t|
      t.integer :user_evaluation_id
      t.integer :numerical_score
      t.text :answer_text
      t.integer :evaluation_question_id
      t.boolean :is_completed

      t.timestamps
    end
  end
end
