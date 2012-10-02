class MoreSettings2 < ActiveRecord::Migration
  def up
    change_table :settings do |t|
      t.decimal :startup_fee, :default => 100.0
      t.decimal :startup_fee_slack_days, :default => 7
      t.decimal :annual_fee_slack_days, :default => 30
    end
  end

  def down
    remove_column :settings, :startup_fee
    remove_column :settings, :startup_fee_slack_days
    remove_column :settings, :annual_fee_slack_days
  end
end
