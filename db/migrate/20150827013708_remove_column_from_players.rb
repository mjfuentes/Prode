class RemoveColumnFromPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :facebook_id, :string
  end
end
