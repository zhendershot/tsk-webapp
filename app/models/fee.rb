class Fee < ActiveRecord::Base
  belongs_to :member
  belongs_to :marked_paid_by, :foreign_key => "marked_paid_by", :class_name => "Member"
  attr_accessible :amount, :due, :marked_paid_by, :paid, :paypal, :member, :member_id, :kind
end
