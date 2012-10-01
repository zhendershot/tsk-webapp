class AddMoreContactInfo < ActiveRecord::Migration
  def self.up
    add_column :members, :phone, :text
    add_column :members, :extra_emails, :text
  end

  def self.down
    remove_column :members, :phone
    remove_column :members, :extra_emails
  end
end
