class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :username
      t.string :password
      t.boolean :admin
      t.timestamps null: false
    end
  end
end
