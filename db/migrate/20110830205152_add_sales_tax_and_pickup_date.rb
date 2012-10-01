class AddSalesTaxAndPickupDate < ActiveRecord::Migration
  def self.up
    add_column :orders, :pickup_on, :datetime
  end

  def self.down
    remove_column :orders, :pickup_on
  end
end
