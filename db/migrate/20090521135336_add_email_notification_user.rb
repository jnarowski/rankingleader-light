class AddEmailNotificationUser < ActiveRecord::Migration
  def self.up
    add_column :users, :send_notifications, :boolean 
  end

  def self.down
  end
end
