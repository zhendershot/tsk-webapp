class Product < ActiveRecord::Base
  has_many :stocks
  has_many :order_details

  Units = ["pounds","ounces","fluid ounces","grams","ml","cl","liters","dozen","packages","boxes","units","cans","jars"]

  def unit_type
    if ["pounds","ounces","grams"].include? self.units
      "weight"
    elsif ["fluid ounces","milliliters","centiliters","liters"].include? self.units
      "volume"
    elsif ["dozen","packages","boxes","units","cans","jars"].include? self.units
      "count"
    else
      nil
    end
  end
end
