class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.text :prompt_text
      t.integer :class_id

      t.timestamps
    end
  end
end
