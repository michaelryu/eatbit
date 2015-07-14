require 'test_helper'

class TextsControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

end
