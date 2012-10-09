class StockVote < ActiveRecord::Base
  belongs_to :member
  belongs_to :stock
  # attr_accessible :title, :body
end
