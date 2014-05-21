require 'test_helper'

class AutocompleteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get autocomplete_results" do
    get :autocomplete_results
    assert_response :success
  end

  test "should get model" do
    get :model
    assert_response :success
  end

  test "should get query_term" do
    get :query_term
    assert_response :success
  end

end
