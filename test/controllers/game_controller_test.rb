require 'test_helper'

class GameControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test "show_fail_unauthorized" do
	    get(:show, {'id' => "4"})
	    assert_redirected_to root_path
  	end

  	test "show_not_found" do
		sign_in :user, users(:matias)
	    get(:show, {'id' => "8"})
	    assert_redirected_to game_history_path
  	end

  	test "show_ok" do
  		sign_in :user, users(:matias)
	    get(:show, {'id' => matchdays(:finished_prueba)})
	    assert_response :success
	    assert_not_nil assigns(:items)
	    assert_equal assigns(:items).size, 2
	    assert_equal assigns(:items)[0]["guess"].points, 5
	    assert_equal assigns(:items)[1]["guess"].points, 0
  	end

  	test "ranking_show" do
  		sign_in :user, users(:matias)
	    get :ranking
	    assert_response :success
	    assert_not_nil assigns(:players)
	    assert_equal assigns(:players).size, User.where(admin:false).size
	    assert_equal assigns(:players)[0]["points"], 10
	    assert_equal assigns(:players)[1]["points"], 5
	    assert_equal assigns(:players)[2]["points"], 2
  	end

  	test "history_unauthorized" do
	    get :history
	    assert_redirected_to root_path
  	end

  	test "history_unauthorized_admin" do
  		sign_in :user, users(:admin)
	    get :history
	    assert_redirected_to root_path
  	end

  	test "history_ok_matias" do
  		sign_in :user, users(:matias)
	    get :history
	    assert_response :success
	    assert_not_nil assigns(:matchdays)
  	end

  	test "simulate_unauthorized" do
  		get(:simulate)
	    assert_redirected_to root_path
  	end

  	test "simulate_unauthorized_user" do
  		sign_in :user, users(:matias)
  		get(:simulate)
	    assert_redirected_to root_path
  	end

  	test "simulate_fail_active_matchday_exists" do
  		sign_in :user, users(:admin)
  		get(:simulate)
	    assert_redirected_to home_path
  	end

  	test "simulate_fail_created_matchday_exists" do
  		sign_in :user, users(:admin)
  		get(:simulate)
	    assert_redirected_to home_path
  	end

  	test "simulate_fail_started_matchday_exists" do
  		matchdays(:not_started).simulate
  		sign_in :user, users(:admin)
  		get(:simulate)
	    assert_redirected_to home_path
  	end

  	test "simulate_ok" do
  		matchdays(:not_started).simulate
  		matchdays(:started).simulate
  		sign_in :user, users(:admin)
  		get(:simulate)
	    assert_redirected_to home_path
	    assert_not_nil Matchday.get_active
  	end
end
