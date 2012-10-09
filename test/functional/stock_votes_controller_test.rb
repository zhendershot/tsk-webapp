require 'test_helper'

class StockVotesControllerTest < ActionController::TestCase
  setup do
    @stock_vote = stock_votes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_votes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_vote" do
    assert_difference('StockVote.count') do
      post :create, stock_vote: {  }
    end

    assert_redirected_to stock_vote_path(assigns(:stock_vote))
  end

  test "should show stock_vote" do
    get :show, id: @stock_vote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_vote
    assert_response :success
  end

  test "should update stock_vote" do
    put :update, id: @stock_vote, stock_vote: {  }
    assert_redirected_to stock_vote_path(assigns(:stock_vote))
  end

  test "should destroy stock_vote" do
    assert_difference('StockVote.count', -1) do
      delete :destroy, id: @stock_vote
    end

    assert_redirected_to stock_votes_path
  end
end
