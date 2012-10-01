class AddDateToService < ActiveRecord::Migration
  def self.up
    add_column :services, :did_at, :datetime
  end

  def self.down
    remove_column :services, :did_at
  end
end
