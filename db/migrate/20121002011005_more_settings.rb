class MoreSettings < ActiveRecord::Migration
  def up
    change_table :settings do |t|
      t.integer :num_months_under_disable, :default => 3
      t.decimal :annual_fee, :default => 100.0
    end
  end

  def down
    remove_column :settings, :num_months_under_disable
    remove_column :settings, :annual_fee
  end
end
