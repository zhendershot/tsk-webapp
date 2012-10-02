class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.string :kind
      t.decimal :amount
      t.date :due
      t.references :member
      t.boolean :paid
      t.boolean :paypal
      t.integer :marked_paid_by

      t.timestamps
    end
    add_index :fees, :member_id
  end
end
