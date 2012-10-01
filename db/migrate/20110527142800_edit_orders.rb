class EditOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :taken, :boolean, :default => false, :null => false
    add_column :orders, :paid, :boolean, :default => false, :null => false
    remove_column :orders, :cost
  end

  def self.down
    remove_column :orders, :taken
    remove_column :orders, :paid
    add_columns :orders, :cost, :decimal, :precision => 10, :scale => 2
  end
end
