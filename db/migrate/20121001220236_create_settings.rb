class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.decimal :sales_tax
      t.decimal :global_markup_percent
      t.decimal :paypal_fee_percent
      t.decimal :paypal_fee_per
      t.string :pickup_dows
      t.decimal :workshare_hours_per_month

      t.timestamps
    end
  end
end
