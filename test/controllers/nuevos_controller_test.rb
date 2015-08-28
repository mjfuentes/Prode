require 'test_helper'

class NuevosControllerTest < ActionController::TestCase
  setup do
    @nuevo = nuevos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nuevos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nuevo" do
    assert_difference('Nuevo.count') do
      post :create, nuevo: {  }
    end

    assert_redirected_to nuevo_path(assigns(:nuevo))
  end

  test "should show nuevo" do
    get :show, id: @nuevo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nuevo
    assert_response :success
  end

  test "should update nuevo" do
    patch :update, id: @nuevo, nuevo: {  }
    assert_redirected_to nuevo_path(assigns(:nuevo))
  end

  test "should destroy nuevo" do
    assert_difference('Nuevo.count', -1) do
      delete :destroy, id: @nuevo
    end

    assert_redirected_to nuevos_path
  end
end
