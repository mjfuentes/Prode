require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

	test "fail_save" do
  		player = Player.new()
  		assert_not player.save
  	end

  	test "fail_save_two" do
  		player = Player.new(name: "matias",username: "matias", password: "123456", email: "matias.fuentes@gmail.com")
  		assert_not player.save
  	end

  	test "player_save" do
  		player = Player.new(name: "matias",username: "matias", password: "123456", email: "matias.fuentes@gmail.com", admin:false)
  		assert player.save
  	end

  	test "admin_save" do
  		player = Player.new(name: "matias",username: "admin", password: "123456", email: "admin", admin:true)
  		assert player.save
  	end

  	test "get_by_username" do
  		player = Player.new(name: "matias",username: "matias", password: "123456", email: "matias.fuentes@gmail.com", admin:false)
  		player.save
  		player_2 = Player.find_by(email: "matias.fuentes@gmail.com")
  		assert_equal(player, player_2)
  	end

end
