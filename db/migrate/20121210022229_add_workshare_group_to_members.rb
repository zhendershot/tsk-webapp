class AddWorkshareGroupToMembers < ActiveRecord::Migration
  def change
    change_table :members do |t|
      t.string :service_group
    end
  end
end
