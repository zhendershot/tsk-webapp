class ArchiveProfitMargin < ActiveRecord::Migration
  def self.up
    add_column :order_details, :archived_markup_pct, :decimal, :precision => 10, :scale => 2
    add_column :order_details, :archived_markup_const, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :order_details, :archived_markup_pct
    remove_column :order_details, :archived_markup_const
  end
end
