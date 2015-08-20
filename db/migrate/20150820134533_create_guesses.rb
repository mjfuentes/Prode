class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.integer :user_id
      t.integer :match_id
      t.integer :home_score
      t.integer :away_score
      t.integer :points
      t.timestamps null: false
    end
  end
end
