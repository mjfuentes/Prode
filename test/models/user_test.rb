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

end
