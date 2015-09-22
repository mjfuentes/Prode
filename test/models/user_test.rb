require 'test_helper'

class UserTest < ActiveSupport::TestCase

	test "fail_save" do
		player = User.new()
		assert_not player.save
	end

	test "invalid_email" do
		player = User.new(name: "matias", password: "12345678", email: "invalid_email")
		assert_not player.save
	end

	test "invalid_password" do
		player = User.new(name: "matias", password: "short", email: "matias.fuentes@gmail.com")
		assert_not player.save
	end

	test "repeated_email" do
		player = User.new(name: "matias", password: "12345678", email: "matias@gmail.com")
		player_two = User.new(name: "pedro", password: "12345678", email: "matias@gmail.com")
		assert player.save
		assert_not player_two.save
	end

	test "player_save" do
		player = User.new(name: "matias", password: "12345678", email: "matias@gmail.com")
		assert player.save
	end

	test "get_by_username" do
		player = User.new(name: "matias", password: "12345678", email: "matias.fuentes@gmail.com")
		player.save
		player_2 = User.find_by(email: "matias.fuentes@gmail.com")
		assert_equal(player, player_2)
	end

	test "ranking_size" do
		ranking = User.ranking
		assert_equal ranking.size, User.where(admin: false).size
	end

	test "ranking_order" do
		ranking = User.ranking
		for i in 0..ranking.size-2 
			assert ranking[i]["points"] >= ranking[i+1]["points"]
		end
	end

	test "ranking_values" do
		ranking = User.ranking
		assert_equal ranking[0]["points"], 10
		assert_equal ranking[1]["points"], 5
		assert_equal ranking[2]["points"], 2
	end

end
