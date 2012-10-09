class CreateStockVotes < ActiveRecord::Migration
  def change
    create_table :stock_votes do |t|
      t.references :member
      t.references :stock

      t.timestamps
    end
    add_index :stock_votes, :member_id
    add_index :stock_votes, :stock_id
  end
end
