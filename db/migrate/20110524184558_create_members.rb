class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name1
      t.string :name2
      t.string :name3
      t.string :email, :null => false
      t.boolean :active, :null => false, :default => true
      t.boolean :admin, :null => false, :default => false

      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.string :perishable_token, :null => false

      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      t.timestamps
    end

    add_index :members, :email
    add_index :members, :persistence_token
    add_index :members, :last_request_at
  end

  def self.down
    drop_table :members
  end
end
