require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

	test "fail_save" do
		player = Player.new()
		assert_not player.save
	end

  test "invalid_email" do
    player = Player.new(name: "matias",username: "mati", password: "123456", email: "invalid_email", admin: false)
    assert_not player.save
  end

  test "invalid_username" do
    player = Player.new(name: "matias",username: "mati{$    }", password: "123456", email: "matias.fuentes@gmail.com", admin: false)
    assert_not player.save
  end

	test "player_save" do
		player = Player.new(name: "matias",username: "mati", password: "123456", email: "matias@gmail.com", admin:false)
		assert player.save
	end

  test "repeated_username" do
    player = Player.new(name: "matias",username: "mati", password: "123456", email: "matias.fuentes@gmail.com", admin:false)
    player_two = Player.new(name: "pedro",username: "mati", password: "123456", email: "pedro.perez@gmail.com", admin:false)
    assert player.save
    assert_not player_two.save
  end

  test "repeated_email" do
    player = Player.new(name: "matias",username: "mati", password: "123456", email: "matias@gmail.com", admin:false)
    player_two = Player.new(name: "pedro",username: "alex", password: "123456", email: "matias@gmail.com", admin:false)
    assert player.save
    assert_not player_two.save
  end

	test "admin_save" do
		player = Player.new(name: "matias",username: "administrador", password: "123456", email: "matias.fuentes@gmail.com", admin:true)
		assert player.save
	end

	test "get_by_username" do
		player = Player.new(name: "matias",username: "mati", password: "123456", email: "matias.fuentes@gmail.com", admin:false)
		player.save
		player_2 = Player.find_by(email: "matias.fuentes@gmail.com")
		assert_equal(player, player_2)
	end

end
