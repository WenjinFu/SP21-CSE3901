class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.boolean :is_pw_set
      t.timestamps
    end
  end
end
