class DidAtWasBroken < ActiveRecord::Migration
  def up
    Service.all.each{ |s|
      if s.did_at.nil?
        s.did_at = s.created_at
        s.save
      end
    }
  end

  def down
  end
end
