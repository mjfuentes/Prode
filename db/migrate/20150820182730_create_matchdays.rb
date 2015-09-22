class CreateMatchdays < ActiveRecord::Migration
  def change
    create_table :matchdays do |t|
      t.boolean :started
      t.boolean :finished
      t.timestamps null: false
    end
  end
end
