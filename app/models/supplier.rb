class Supplier < ActiveRecord::Base
  has_many :stocks
  has_many :order_details
  attr_accessible :name, :address
end
