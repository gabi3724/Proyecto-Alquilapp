require "test_helper"

class LicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lic = lics(:one)
  end

  test "should get index" do
    get lics_url
    assert_response :success
  end

  test "should get new" do
    get new_lic_url
    assert_response :success
  end

  test "should create lic" do
    assert_difference("Lic.count") do
      post lics_url, params: { lic: { descripcion: @lic.descripcion, estado: @lic.estado, usuario_id: @lic.usuario_id } }
    end

    assert_redirected_to lic_url(Lic.last)
  end

  test "should show lic" do
    get lic_url(@lic)
    assert_response :success
  end

  test "should get edit" do
    get edit_lic_url(@lic)
    assert_response :success
  end

  test "should update lic" do
    patch lic_url(@lic), params: { lic: { descripcion: @lic.descripcion, estado: @lic.estado, usuario_id: @lic.usuario_id } }
    assert_redirected_to lic_url(@lic)
  end

  test "should destroy lic" do
    assert_difference("Lic.count", -1) do
      delete lic_url(@lic)
    end

    assert_redirected_to lics_url
  end
end
