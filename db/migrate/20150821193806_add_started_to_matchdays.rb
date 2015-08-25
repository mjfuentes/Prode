class AddStartedToMatchdays < ActiveRecord::Migration
  def change
    add_column :matchdays, :started, :boolean
  end
end
