class AddJoinedOnToMember < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.date :joined_on
    end
  end
end
