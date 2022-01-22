class AddAdminIdToSection < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :admin_id, :integer
  end
end
