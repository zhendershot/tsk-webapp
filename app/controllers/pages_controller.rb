class PagesController < ApplicationController
  before_filter :authenticate_member!

  def member_info
  end

end
