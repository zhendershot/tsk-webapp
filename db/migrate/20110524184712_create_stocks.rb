class CreateStocks < ActiveRecord::Migration
  def self.up
    create_table :stocks do |t|
      t.string :name
      t.string :units
      t.decimal :quantity, :precision => 10, :scale => 2
      t.decimal :cost, :precision => 10, :scale => 2
      t.string :origin
      t.string :supplier

      t.timestamps
    end
  end

  def self.down
    drop_table :stocks
  end
end
