require 'test_helper'

class KaraokesControllerTest < ActionController::TestCase
  setup do
    @karaoke = karaokes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:karaokes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create karaoke" do
    assert_difference('Karaoke.count') do
      post :create, karaoke: { actor: @karaoke.actor, ballot1: @karaoke.ballot1, introduction: @karaoke.introduction, picture: @karaoke.picture, video1: @karaoke.video1, video2: @karaoke.video2 }
    end

    assert_redirected_to karaoke_path(assigns(:karaoke))
  end

  test "should show karaoke" do
    get :show, id: @karaoke
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @karaoke
    assert_response :success
  end

  test "should update karaoke" do
    patch :update, id: @karaoke, karaoke: { actor: @karaoke.actor, ballot1: @karaoke.ballot1, introduction: @karaoke.introduction, picture: @karaoke.picture, video1: @karaoke.video1, video2: @karaoke.video2 }
    assert_redirected_to karaoke_path(assigns(:karaoke))
  end

  test "should destroy karaoke" do
    assert_difference('Karaoke.count', -1) do
      delete :destroy, id: @karaoke
    end

    assert_redirected_to karaokes_path
  end
end
