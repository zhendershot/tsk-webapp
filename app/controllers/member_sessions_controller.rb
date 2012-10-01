class MemberSessionsController < ApplicationController
  before_filter :require_no_member, :only => [:new, :create]
  before_filter :require_member, :only => :destroy
  
  def new
    @member_session = MemberSession.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @member_session }
    end
  end
  
  def create
    @member_session = MemberSession.new(params[:member_session])
    if @member_session.save
      flash[:notice] = "Login successful!"
      if @member_session.member.admin
        redirect_back_or_default orders_path
      else
        redirect_back_or_default new_order_path
      end 
    else
      render :action => :new
    end
  end
  
  def destroy
    current_member_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_member_session_url
  end
end
