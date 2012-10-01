class CreateOrderDetails < ActiveRecord::Migration
  def self.up
    create_table :order_details do |t|
      t.references :order
      t.decimal :cost, :precision => 10, :scale => 2
      t.decimal :quantity, :precision => 10, :scale => 2
      t.references :stock

      t.timestamps
    end
  end

  def self.down
    drop_table :order_details
  end
end
