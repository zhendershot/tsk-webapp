class OrdersController < ApplicationController
  before_filter :require_owner, :only => [:edit, :update, :destroy, :show]
  before_filter :require_admin, :only => [:toggle_taken, :toggle_paid]

  def require_owner
    unless current_member and (current_member.admin or Order.find(params[:id]).member.id == current_member.id)
      store_location
      flash[:notice] = "Hey, that's not yours!"
      redirect_to orders_path
    end
  end

  # GET /orders
  # GET /orders.xml
  def index
    all = params[:all].to_i == 1
    if current_member.admin
      if all
        @orders = Order.all(:order => "created_at DESC")
      else
        @orders = Order.scoped_by_taken(false).all(:order => "pickup_on, paid, taken")
      end
    else
      if all
        @orders = Order.scoped_by_member_id(current_member.id).all(:order => "pickup_on, paid, taken")
      else
        @orders = Order.scoped_by_taken(false).scoped_by_member_id(current_member.id).all(:order => "pickup_on, paid, taken")
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  def fill
    params[:partial_fill].each{ |odid,pf|
      od = OrderDetail.find(odid.to_i)
      od.partial_fill = pf.to_f
      od.save
    }
    distribution
  end


  def distribution
    @orders = Order.scoped_by_taken(false).scoped_by_paid(true)
    @by_stock = {}
    @orders.each { |o|
      @by_stock[o.pickup_on] = {} if @by_stock[o.pickup_on].nil?
      o.order_details.each{ |od|
        next if od.stock.nil?
        @by_stock[o.pickup_on][od.stock.id] = [] if @by_stock[o.pickup_on][od.stock.id].nil?
        @by_stock[o.pickup_on][od.stock.id].push(od)
      }
    }
    render :distribution
  end

  def markup(by="week")
    by = params[:by].nil? ? "week" : params[:by]
    @orders = Order.scoped_by_taken(true).scoped_by_paid(true).all(:order => "created_at DESC")
    @by_period = {}    
    @orders.each { |o|
      total_cost = 0.0
      total_profit = 0.0
      o.paid_at = o.updated_at if o.paid_at.nil?
      # friday -> thursday is a week!
      if by == "week"
        k = (o.paid_at - (o.paid_at.wday+2)*24*3600).strftime("%Y-%m-%d") + " to " + (o.paid_at + (4-o.paid_at.wday)*24*3600).strftime("%Y-%m-%d")
      elsif by == "month"
        k = o.paid_at.strftime("%Y-%m")
      elsif by == "year"
        k = o.paid_at.year.to_s
      else
        break
      end
      
      o.order_details.each{ |od|
        next if od.archived_cost.nil?

        pct = od.archived_markup_pct.nil? ? 0.0 : od.archived_markup_pct
        cst = od.archived_markup_const.nil? ? 0.0 : od.archived_markup_const

        orig_cost = (od.archived_cost - cst)/(1.0 - (pct/100.0))
        total_cost += orig_cost
        total_profit += orig_cost*(pct/100.0) + cst
      }
      @by_period[k] = {:sales => 0.0, :profit => 0.0, :n => 0} if @by_period[k].nil?
      @by_period[k][:n] += 1
      @by_period[k][:sales] += total_cost
      @by_period[k][:profit] += total_profit
    }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    if current_member.disabled
      flash[:notice] = "Account is disabled. Cannot order until re-enabled."
      redirect_to(root_path)
      return
    end
    @order = Order.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    unless current_member.admin or (!@order.paid and !@order.taken)
      store_location
      flash[:notice] = "Too late to edit that one, bro."
      redirect_to orders_path
    end
  end

  # POST /orders
  # POST /orders.xml
  def create
    notice = ""
    if current_member.disabled
      flash[:notice] = "Account is disabled. Cannot order until re-enabled."
      redirect_to(root_path)
      return
    end
    params[:order][:order_details_attributes].each{ |k,v|
      params[:order][:order_details_attributes].delete(k) if v[:quantity].to_f == 0.0 or v[:quantity].strip == ''
    }

    # combine same-stock entries
    stock_quantities = {}
    params[:order][:order_details_attributes].each{ |k,v|
      sid = v[:stock_id].to_i
      q = v[:quantity].to_f
      if stock_quantities[sid].nil?
        stock_quantities[sid] = q
      else
        stock_quantities[sid] += q
        OrderDetail.find(v[:id]).destroy unless v[:id].nil?
        params[:order][:order_details_attributes].delete(k)
      end
    }
    params[:order][:order_details_attributes].each{ |k,v|
      params[:order][:order_details_attributes][k][:quantity] = stock_quantities[v[:stock_id].to_i]
    }

    @order = Order.new(params[:order])
    unless current_member.admin
      @order.member = current_member
    end

    # first check to make sure there is enough stock available
    @order.order_details.each{ |od|
      if od.stock.limited and od.stock.quantity < od.quantity
        unless current_member.admin
          @order.errors.add "Limited Stock Item:","Sorry, there are only #{od.stock.quantity} #{od.stock.product.units} #{od.stock.name} remaining"
          respond_to do |format|
            format.html { render :action => "new" }
            format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
          end
          return false
        else
          notice = "Limited Stock Item: There were only #{od.stock.quantity} 
                               #{od.stock.product.units} #{od.stock.name} remaining, 
                               but I let you do it anyway since you're the boss!"
        end
      elsif od.stock.quantity < od.quantity and !od.stock.limited
        notice = "You have ordered more than is currently in stock. There may be some delay in filling this order-item."
      end
    }

    respond_to do |format|
      if @order.save
        # calculate costs and update stock
        @order.order_details.each{ |od|
          od.stock.quantity -= od.quantity
          od.stock.save
        }
        format.html { redirect_to(orders_path, :notice => "Order was successfully created. #{notice}") }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  def toggle_taken
    notice = ''
    @order = Order.find(params[:id])
    unless @order.taken
      @order.taken = true
      @order.taken_at = Time.now
      @order.archived = true
      @order.order_details.each{ |od|
        unless od.stock.nil?
          od.archived_name = od.stock.name
          od.archived_cost = od.stock.final_cost
          od.archived_supplier = od.stock.supplier
          od.archived_product = od.stock.product
          od.archived_markup_pct = od.stock.markup_pct
          od.archived_markup_const = od.stock.markup_const
          od.save
        end
      }
    else
      @order.taken = false
      @order.archived = false
    end
    @order.save
    redirect_to orders_path
  end

  def toggle_paid
    notice = ''
    @order = Order.find(params[:id])
    unless @order.paid
      @order.paid = true
      @order.paid_at = Time.now
      @order.marked_paid_by = current_member
      @order.paid_with_paypal = (params[:paypal].to_i == 1)
    else
      if params[:paypal].to_i == 1
        @order.paid_with_paypal = !@order.paid_with_paypal
      else
        @order.paid_with_paypal = false
        @order.paid = false
      end
    end
    @order.save
    redirect_to orders_path
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    notice = ''
    @order = Order.find(params[:id])
    unless current_member.admin or (!@order.paid and !@order.taken)
      store_location
      flash[:notice] = "Too late to edit that one, bro."
      redirect_to orders_path
    end

    # remove empty items
    params[:order][:order_details_attributes].each{ |k,v|
      if v[:id].nil?
        params[:order][:order_details_attributes].delete(k) if v[:quantity].to_f == 0.0 or v[:quantity].strip == ''
        next
      end

      if v[:quantity].to_f == 0.0 or v[:quantity].strip == ''
        OrderDetail.find(v[:id]).destroy
        params[:order][:order_details_attributes].delete(k)
      end
    }

    # combine same-stock entries
    stock_quantities = {}
    params[:order][:order_details_attributes].each{ |k,v|
      sid = v[:stock_id].to_i
      q = v[:quantity].to_f
      if stock_quantities[sid].nil?
        stock_quantities[sid] = q
      else
        stock_quantities[sid] += q
        OrderDetail.find(v[:id]).destroy unless v[:id].nil?
        params[:order][:order_details_attributes].delete(k)
      end
    }
    params[:order][:order_details_attributes].each{ |k,v|
      params[:order][:order_details_attributes][k][:quantity] = stock_quantities[v[:stock_id].to_i]
    }
       
    unless current_member.admin
      @order.member = current_member
    end

    old_stock_quantities = {}
    @order.order_details.each{ |od|
      next if od.stock.nil?
      old_stock_quantities[od.stock.id] = od.quantity
    }    

    # first check to make sure there is enough stock available
    stock_quantities.each{ |sid,q|
      s = Stock.find(sid)
      old_stock_quantities[sid] = 0.0 if old_stock_quantities[sid].nil?
      qmax = s.quantity + old_stock_quantities[sid]
      if s.limited and qmax < stock_quantities[sid]
        unless current_member.admin
          @order.errors.add "Limited Stock Item:","Sorry, there are only #{qmax} #{s.product.units} #{s.name} remaining and you have tried to order #{stock_quantities[sid]}."
          respond_to do |format|
            format.html { render :action => "new" }
            format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
          end
          return false
        else
          notice = "Limited Stock Item: There were only #{qmax} 
                               #{s.product.units} #{s.name} remaining, 
                               but I let you do it anyway since you're the boss!"
        end
      elsif !s.limited and qmax < stock_quantities[sid]
        notice = "You ordered more #{s.name} than is currently in stock. It may be some delay before this order item is available for pick up."
      end
    }

    # add back quantity and then subtract it off again
    @order.order_details.each{ |od|
      next if od.stock.nil?
      od.stock.quantity += od.quantity
      od.stock.save
    }
    if !@order.paid and params[:order][:paid].to_i == 1
      @order.paid_at = Time.now
      @order.marked_paid_by = current_member
      @order.save
    end

    if !@order.taken and params[:order][:taken].to_i == 1
      @order.taken_at = Time.now
      @order.archived = true
      @order.save
    end

    # delete items before we add back the new ones
    @order.order_details = []
    @order.save   

    respond_to do |format|
   
      if @order.update_attributes(params[:order])
        @order.order_details.each{ |od|
          next if od.stock.nil?
          od.stock.quantity -= od.quantity
          od.stock.save
          if @order.archived
            od.archived_name = od.stock.name
            od.archived_cost = od.stock.final_cost
            od.archived_supplier = od.stock.supplier
            od.archived_product = od.stock.product
            od.archived_markup_pct = od.stock.markup_pct
            od.archived_markup_const = od.stock.markup_const
          end
          od.save
        }
        format.html { redirect_to(orders_path, :notice => "Order was successfully updated. #{notice}") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    unless current_member.admin or (!@order.paid and !@order.taken)
      store_location
      flash[:notice] = "Too late to edit that one, bro."
      redirect_to orders_path
    end

    # add stock back
    @order.order_details.each{ |od|
      od.stock.quantity += od.quantity
      od.stock.save
    }

    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
