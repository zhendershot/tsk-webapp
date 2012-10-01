class AuthlogicToDevise < ActiveRecord::Migration

  def self.up
    change_table :members do |t|
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end
    Member.all.each do |user|
      user.sign_in_count = user.login_count
      user.current_sign_in_at = user.current_login_at
      user.last_sign_in_at = user.last_login_at
      user.current_sign_in_ip = user.current_login_ip
      user.last_sign_in_ip = user.last_login_ip
      user.save!
    end
    remove_column :members, :crypted_password
    remove_column :members, :login_count
    remove_column :members, :current_login_at
    remove_column :members, :last_login_at
    remove_column :members, :current_login_ip
    remove_column :members, :last_login_ip
    remove_column :members, :failed_login_count
    remove_column :members, :last_request_at
    drop_table :sessions
    Member.all.each do |user|
      user.password = "changeme"
      user.save
    end
  end

  def self.down
  end
end
