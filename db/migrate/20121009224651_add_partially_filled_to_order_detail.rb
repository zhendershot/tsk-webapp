class AddPartiallyFilledToOrderDetail < ActiveRecord::Migration
  def change
    change_table :order_details do |t|
      t.decimal :partial_fill
    end
  end
end
