class CreateFees < ActiveRecord::Migration
  def self.up
    create_table :fees do |t|
      t.references :member
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :fees
  end
end
