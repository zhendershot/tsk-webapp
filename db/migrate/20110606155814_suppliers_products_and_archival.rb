class SuppliersProductsAndArchival < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.timestamp :taken_at
      t.timestamp :paid_at
      t.integer :marked_paid_by
      t.boolean :archived, :null => false, :default => :false
    end
    remove_column :order_details, :cost
    change_table :order_details do |t|
      t.integer :archived_supplier
      t.integer :archived_product
      t.string :archived_name
      t.decimal :archived_cost, :precision => 10, :scale => 2
    end
    change_table :stocks do |t|
      t.references :supplier
      t.references :product
    end
    change_table :services do |t|
      t.integer :observed_by
    end

  end

  def self.down
    remove_column :orders, :taken_at
    remove_column :orders, :paid_at
    remove_column :orders, :marked_paid_by
    remove_column :orders, :archived
    remove_column :order_details, :archived_supplier
    remove_column :order_details, :archived_product
    remove_column :order_details, :archived_name
    remove_column :order_details, :archived_cost
    add_column :order_details, :cost, :decimal, :precision => 10, :scale => 2
    remove_column :stocks, :supplier_id
    remove_column :stocks, :product_id
    remove_column :services, :observed_by
  end

end
