class Service < ActiveRecord::Base
  belongs_to :member
  belongs_to :observed_by, :foreign_key => "observed_by", :class_name => "Member"
end
