class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :stock
  belongs_to :archived_product, :foreign_key => "archived_product", :class_name => "Product"
  belongs_to :archived_supplier, :foreign_key => "archived_supplier", :class_name => "Supplier"
  validates_presence_of :quantity

  def grams
    self.order.archived ? Stock.grams(self.quantity,self.archived_product) : Stock.grams(self.quantity,self.stock.product)
  end
end
