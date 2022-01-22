class CreateEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluations do |t|
      t.string :name
      t.datetime :due_date

      t.timestamps
    end
  end
end
