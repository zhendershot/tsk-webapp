class Stock < ActiveRecord::Base
  has_many :order_details
  belongs_to :product
  belongs_to :supplier
  validates_presence_of :name, :cost, :quantity
  attr_accessible :name, :quantity, :cost, :markup_pct, :markup_const, :origin, :supplier_id, :product_id, :limited

  def grams(x=self.quantity,p=self.product)
    if p.unit_type == "weight"
      to_g = {"pounds" => 453.59237, "kilos" => 1000.0, "grams" => 1.0, "ounces" => 28.3495231}
      return to_g[p.units].nil? ? nil : to_g[p.units]*x
    elsif p.unit_type == "volume"
      to_ml = {"fluid ounces" => 29.5735296, "liters" => 1000.0, "cl" => 10.0}
      return (to_ml[p.units].nil? or p.density_g_per_ml.nil?)  ? nil : to_ml[p.units]*p.density_g_per_ml*x
    end
    return nil
  end

  def final_cost
    self.cost + self.cost*(self.markup_pct/100.0) + self.markup_const + self.cost*(Setting.first.global_markup_percent/100.0)
  end

  def available_items
    where("(limited = 'f') OR (limited = 't' AND quantity > 0)",:order => "name")
  end
end
