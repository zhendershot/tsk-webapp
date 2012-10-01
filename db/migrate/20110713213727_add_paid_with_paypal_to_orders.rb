class AddPaidWithPaypalToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :paid_with_paypal, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :orders, :paid_with_paypal
  end
end
