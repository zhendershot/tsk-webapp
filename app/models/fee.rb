class Fee < ActiveRecord::Base
  belongs_to :member
  belongs_to :marked_paid_by, :foreign_key => "marked_paid_by", :class_name => "Member"
  attr_accessible :amount, :due, :marked_paid_by, :paid, :paypal, :member, :member_id, :kind

  def pretax_cost
    self.amount
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
