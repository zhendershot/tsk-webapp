class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :member
      t.decimal :cost, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
