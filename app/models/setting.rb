class Setting < ActiveRecord::Base
  attr_accessible :global_markup_percent, :paypal_fee_per, :paypal_fee_percent, :pickup_dows, :sales_tax, :workshare_hours_per_month, :num_months_under_disable, :annual_fee, :startup_fee, :startup_fee_slack_days, :annual_fee_slack_days
end
