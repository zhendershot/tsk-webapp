class AddBitsToMember < ActiveRecord::Migration
  def up
    change_table :members do |t|
      t.boolean :disabled, :default => false
      t.text :disabled_reason
    end
    remove_column :members, :active
  end
  def down
    remove_column :members, :disabled
    remove_column :members, :disabled_reason
    add_column :members, :active, :boolean, :default => 't'
  end
end
