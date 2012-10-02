class RemovePasswordSalt < ActiveRecord::Migration
  def up
    remove_column :members, :password_salt
    remove_column :members, :persistence_token
    remove_column :members, :perishable_token
  end

  def down
    add_column :members, :password_salt, :string
    add_column :members, :persistence_token, :string
    add_column :members, :perishable_token, :string
  end
end
