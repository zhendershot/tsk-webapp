class SmallFixes < ActiveRecord::Migration
  def self.up
    remove_column :stocks, :supplier
    remove_column :stocks, :units
    add_column :products, :units, :string
    add_column :products, :category, :string
    remove_column :order_details, :archived_cost
    add_column :order_details, :archived_cost, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    add_column :stocks, :supplier, :string
    add_column :stocks, :units, :string
    remove_column :products, :category
    remove_column :products, :units
    remove_column :order_details, :archived_cost
    add_column :order_details, :archived_cost, :string
  end
end
