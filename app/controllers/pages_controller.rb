class PagesController < ApplicationController
  before_filter :require_member, :only => "member_info"

  def member_info
  end

end
