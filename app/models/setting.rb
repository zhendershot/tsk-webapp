class Setting < ActiveRecord::Base
  attr_accessible :global_markup_percent, :paypal_fee_per, :paypal_fee_percent, :pickup_dows, :sales_tax
end
