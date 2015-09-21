class AddFacebookidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebookid, :integer, :limit => 8
  end
end
