class AddLimitedStock < ActiveRecord::Migration
  def self.up
    add_column :stocks, :limited, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :stocks,:limited
  end
end
