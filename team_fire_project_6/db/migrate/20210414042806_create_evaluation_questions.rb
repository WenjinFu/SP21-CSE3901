class CreateEvaluationQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluation_questions do |t|
      t.references :evaluation, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
