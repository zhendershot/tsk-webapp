class FeesController < ApplicationController
  before_filter :require_admin, :only => [:toggle_paid,:edit,:update,:new,:create,:index]

  def toggle_paid
    notice = ''
    @fee = Fee.find(params[:id])
    unless @fee.paid
      @fee.paid = true
      @fee.marked_paid_by = current_member
      @fee.paypal = (params[:paypal].to_i == 1)
    else
      if params[:paypal].to_i == 1
        @fee.paypal = !@fee.paypal
      else
        @fee.paypal = false
        @fee.paid = false
      end
    end
    @fee.save
    redirect_to fees_path
  end


  def mine
    @fees = Fee.where("member_id = ?",current_member.id)
    render :index
  end

  # GET /fees
  # GET /fees.json
  def index
    @fees = Fee.all

    respond_to do |format|
      format.html { render :index }# index.html.erb
      format.json { render json: @fees }
    end
  end

  # GET /fees/new
  # GET /fees/new.json
  def new
    @fee = Fee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fee }
    end
  end

  # GET /fees/1/edit
  def edit
    @fee = Fee.find(params[:id])
  end

  # POST /fees
  # POST /fees.json
  def create
    @fee = Fee.new(params[:fee])

    respond_to do |format|
      if @fee.save
        format.html { redirect_to fees_path, notice: 'Fee was successfully created.' }
        format.json { render json: @fee, status: :created, location: @fee }
      else
        format.html { render action: "new" }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fees/1
  # PUT /fees/1.json
  def update
    @fee = Fee.find(params[:id])

    respond_to do |format|
      if @fee.update_attributes(params[:fee])
        format.html { redirect_to fees_path, notice: 'Fee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fees/1
  # DELETE /fees/1.json
  def destroy
    @fee = Fee.find(params[:id])
    @fee.destroy

    respond_to do |format|
      format.html { redirect_to fees_url }
      format.json { head :no_content }
    end
  end
end
