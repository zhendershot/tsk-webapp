class MarkupAndDensity < ActiveRecord::Migration
  def self.up
    add_column :products, :density_g_per_ml, :decimal, :precision => 12, :scale => 6
    add_column :stocks, :markup_pct, :decimal, :precision => 10, :scale => 2, :null => false, :default => 0.0
    add_column :stocks, :markup_const, :decimal, :precision => 10, :scale => 2, :null => false, :default => 0.0
    add_column :products, :servings_per_unit, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :products, :density_g_per_ml
    remove_column :stocks, :markup_pct
    remove_column :stocks, :markup_const
    remove_column :products, :servings_per_unit
  end
end
