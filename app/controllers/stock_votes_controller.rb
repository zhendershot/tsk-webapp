class StockVotesController < ApplicationController
  # GET /stock_votes
  # GET /stock_votes.json
  def index
    @votes = {}
    @stock = Stock.all.sort{ |x,y|
      a = x.product.nil? ? "Unknown" : x.product.category
      b = y.product.nil? ? "Unknown" : y.product.category
      a <=> b
    }
    StockVote.where("member_id = ?",current_member.id).each{ |sv| @votes[sv.stock.id] = true }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  def summary
    @votes = {}
    StockVote.all.each{ |sv| 
      @votes[sv.stock.id] = 0 if @votes[sv.stock.id].nil?
      @votes[sv.stock.id] += 1
    }
    @stock = Stock.all.sort{ |x,y| 
      a = @votes[x.id].nil? ? 0 : @votes[x.id]
      b = @votes[y.id].nil? ? 0 : @votes[y.id]
      b <=> a
    }
    @mcount = Member.all.count
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  def toggle
    found = StockVote.where("member_id = ? AND stock_id = ?",current_member.id,params[:id].to_i)
    if found.nil? or found.length == 0
      sv = StockVote.new
      sv.member_id = current_member.id
      sv.stock_id = params[:id]
      sv.save
    else
      found.each{ |sv|
        sv.destroy
      }
    end
    respond_to do |format|
      format.html { redirect_to stock_votes_url }
      format.json { head :no_content }
    end
  end

end
