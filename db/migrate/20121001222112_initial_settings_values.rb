class InitialSettingsValues < ActiveRecord::Migration
  def up
    s = Setting.new
    s.sales_tax = 3.41
    s.global_markup_percent = 0.00
    s.paypal_fee_percent = 0.029
    s.paypal_fee_per = 0.30
    s.pickup_dows = "3:6"
    s.workshare_hours_per_month = 2.0
    s.save
  end

  def down
    Setting.all.each{ |s|
      s.destroy
    }
  end
end
