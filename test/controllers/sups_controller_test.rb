require "test_helper"

class SupsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sups_new_url
    assert_response :success
  end

  test "should get create" do
    get sups_create_url
    assert_response :success
  end

  test "should get show" do
    get sups_show_url
    assert_response :success
  end

  test "should get index" do
    get sups_index_url
    assert_response :success
  end
end
