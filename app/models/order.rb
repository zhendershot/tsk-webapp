class Order < ActiveRecord::Base
  belongs_to :member
  belongs_to :marked_paid_by, :foreign_key => "marked_paid_by", :class_name => "Member"
  has_many :order_details, :dependent => :destroy
  accepts_nested_attributes_for :order_details, :allow_destroy => true
  validates_presence_of :pickup_on
  attr_accessible :member_id, :paid, :taken, :paid_with_paypal, :pickup_on, :order_details_attributes, :notes

  def pretax_cost
    sum = 0.0
    order_details.each { |od|
      unless self.archived
        next if od.stock.nil? # shouldn't happen...
        sum += od.stock.final_cost*od.quantity
      else
        next if od.archived_cost.nil?
        sum += od.archived_cost*od.quantity
      end
    }
    return sum.round(2)
  end

  def tax
    (self.pretax_cost*(Setting.first.sales_tax/100.0)).round(2)
  end

  def cost
    self.pretax_cost + self.tax
  end

  def paypal_cost
    return self.cost + self.cost*(Setting.first.paypal_fee_percent/100.0) + Setting.first.paypal_fee_per
  end
end
