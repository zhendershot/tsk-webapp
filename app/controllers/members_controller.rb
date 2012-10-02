class MembersController < ApplicationController
  before_filter :require_admin, :only => [:new, :create]
  before_filter :require_owner, :only => [:edit, :update]

  def require_owner
    unless current_member and current_member.admin or params[:id] == current_member.id
      store_location
      flash[:notice] = "Hey, that's not yours!"
      redirect_to account_path
    end
  end

  # GET /members
  # GET /members.xml
  def index
    @members = Member.all(:order => :name1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @members }
    end
  end

  def home
    show
  end

  # GET /members/1
  # GET /members/1.xml
  def show
    @member = params[:id].nil? ? current_member : Member.find(params[:id])
    unless current_member.admin or @member.id == current_member.id
      store_location
      flash[:notice] = "Hey, that's not yours!"
      redirect_to account_path
    else
      respond_to do |format|
        format.html { render :show } # show.html.erb
        format.xml  { render :xml => @member }
      end
    end
  end

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to(@member, :notice => 'Member was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.xml
  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to(members_url) }
      format.xml  { head :ok }
    end
  end
end
