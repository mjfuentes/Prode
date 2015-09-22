require 'test_helper'

class MatchdaysControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	test "index_fail_guest" do
	    get(:index)
	    assert_redirected_to root_path
  	end

  	test "index_fail_user" do
		sign_in :user, users(:matias)
	    get(:index)
	    assert_redirected_to root_path
  	end

  	test "index_ok" do
		sign_in :user, users(:admin)
	    get(:index)
	    assert_response :success
	    assert_not_nil assigns(:matchdays)
	    assert_equal assigns(:matchdays).size, 4
  	end

  	test "show_fail_guest" do
	    get(:show, {'id' => matchdays(:finished_prueba)})
	    assert_redirected_to root_path
  	end

  	test "show_fail_user" do
		sign_in :user, users(:matias)
	    get(:show, {'id' => matchdays(:finished_prueba)})
	    assert_redirected_to root_path
  	end

  	test "show_not_found" do
		sign_in :user, users(:admin)
	    get(:show, {'id' => 23})
	    assert_redirected_to matchdays_path
  	end

  	test "show_ok" do
		sign_in :user, users(:admin)
	    get(:show, {'id' => matchdays(:finished_prueba)})
	    assert_response :success
	    assert_not_nil assigns(:matches)
	    assigns(:matches) do |match|
	    	assert_equal match.id, matchdays(:finished_prueba).id
	    end
  	end

  	test "new_fail_guest" do
	 	get(:new)
	    assert_redirected_to root_path
  	end

  	test "new_fail_user" do
  		sign_in :user, users(:matias)
	 	get(:new)
	    assert_redirected_to root_path
  	end

  	test "new_fail_already_active_matchday" do
  		sign_in :user, users(:admin)
	 	get(:new)
	    assert_redirected_to matchdays_path
  	end

	test "new_ok" do
  		sign_in :user, users(:admin)
  		matchdays(:not_started).simulate
  		matchdays(:started).simulate
	 	get(:new)
	    assert_redirected_to(controller: "matchdays", action: "show", id: Matchday.last.id)
  	end

  	test "start_fail_guest" do
	 	get(:start, {'id' => matchdays(:started).id})
	    assert_redirected_to root_path
  	end

  	test "start_fail_user" do
  		sign_in :user, users(:matias)
	 	get(:start, {'id' => matchdays(:started).id})
	    assert_redirected_to root_path
  	end

  	test "start_fail_already_started" do
  		sign_in :user, users(:admin)
	 	assert matchdays(:started).started
	 	get(:start, {'id' => matchdays(:started).id})
	    assert_redirected_to(controller: "matchdays", action: "show", id: matchdays(:started).id)
	    assert matchdays(:started).started
  	end

  	test "start_not_found" do
		sign_in :user, users(:admin)
	    get(:start, {'id' => 23})
	    assert_redirected_to matchdays_path
  	end

	test "start_ok" do
  		sign_in :user, users(:admin)
	 	assert_not matchdays(:not_started).started
	 	get(:start, {'id' => matchdays(:not_started).id})
	    assert_redirected_to(controller: "matchdays", action: "show", id: matchdays(:not_started).id)
  		matchdays(:started).simulate
	    assert_equal Matchday.get_active.id,matchdays(:not_started).id
  	end

  	test "end_fail_guest" do
	 	get(:end, {'id' => matchdays(:started).id})
	    assert_redirected_to root_path
  	end

  	test "end_fail_user" do
  		sign_in :user, users(:matias)
	 	get(:end, {'id' => matchdays(:started).id})
	    assert_redirected_to root_path
  	end

  	test "end_fail_already_ended" do
  		sign_in :user, users(:admin)
	 	get(:end, {'id' => matchdays(:finished_prueba).id})
	 	assert matchdays(:ended).finished
	    assert_redirected_to(controller: "matchdays", action: "show", id: matchdays(:finished_prueba).id)
	    assert matchdays(:ended).finished
  	end

  	test "end_not_found" do
		sign_in :user, users(:admin)
	    get(:show, {'id' => 23})
	    assert_redirected_to matchdays_path
  	end

	test "end_ok" do
  		sign_in :user, users(:admin)
	 	get(:end, {'id' => matchdays(:started).id})
	 	assert_not matchdays(:started).finished
	    assert_redirected_to(controller: "matchdays", action: "show", id: matchdays(:started).id)
	    assert Matchday.find(matchdays(:started).id).finished
  	end

  	test "simulate_results_fail_guest" do
	 	get(:simulate_results, {'id' => matchdays(:started).id})
	    assert_redirected_to root_path
  	end

  	test "simulate_results_fail_user" do
  		sign_in :user, users(:matias)
	 	get(:simulate_results, {'id' => matchdays(:started).id})
	    assert_redirected_to root_path
  	end

  	test "simulate_matchday_not_active" do
  		sign_in :user, users(:admin)
	 	get(:simulate_results, {'id' => matchdays(:finished_prueba).id})
	    assert_redirected_to home_path
  	end

  	test "simulate_results_matchday_not_found" do
		sign_in :user, users(:admin)
	    get(:simulate_results, {'id' => 23})
	    assert_redirected_to matchdays_path
  	end

	test "simulate_results_ok" do
  		sign_in :user, users(:admin)
	 	matchdays(:not_started).destroy
	 	get(:simulate_results, {'id' => matchdays(:started).id})
	 	assert_redirected_to(controller: "matchdays", action: "show", id: matchdays(:started).id)
	 	matchday = Matchday.find(matchdays(:started).id)
	 	assert matchday.finished
	 	matchday.matches do |match|
	 		assert match.finished
	 		assert match.home_score >= 0 and match.home_score <= 5
	 		assert match.away_score >= 0 and match.away_score <= 5
	 	end
  	end
end
