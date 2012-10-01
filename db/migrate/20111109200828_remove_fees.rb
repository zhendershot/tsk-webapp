class RemoveFees < ActiveRecord::Migration
  def self.up
    drop_table :fees
  end

  def self.down
    create_table :fees do |t|
      t.references :member
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :description

      t.timestamps
    end
  end
end
