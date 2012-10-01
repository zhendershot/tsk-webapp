class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :current_member_session, :current_member
  filter_parameter_logging :password, :password_confirmation

  private

  def current_member_session
    return @current_member_session if defined?(@current_member_session)
    @current_member_session = MemberSession.find
  end

  def current_member
    return @current_member if defined?(@current_member)
    @current_member = current_member_session && current_member_session.member
  end

  def require_member
    unless current_member
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to root_path
      return false
    end
  end

  def require_no_member
    if current_member
      store_location
      #flash[:notice] = "You must be logged out to access this page"
      redirect_to orders_path
      return false
    end
  end

  def require_admin
    unless current_member and current_member.admin
      store_location
      flash[:notice] = "You must be an administrator to access that page"
      redirect_to account_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
    
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
