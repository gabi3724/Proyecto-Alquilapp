require "test_helper"

class AutosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get autos_new_url
    assert_response :success
  end

  test "should get create" do
    get autos_create_url
    assert_response :success
  end

  test "should get show" do
    get autos_show_url
    assert_response :success
  end

  test "should get index" do
    get autos_index_url
    assert_response :success
  end
end
