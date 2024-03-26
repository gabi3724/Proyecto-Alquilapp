require "application_system_test_case"

class LicsTest < ApplicationSystemTestCase
  setup do
    @lic = lics(:one)
  end

  test "visiting the index" do
    visit lics_url
    assert_selector "h1", text: "Lics"
  end

  test "should create lic" do
    visit lics_url
    click_on "New lic"

    fill_in "Descripcion", with: @lic.descripcion
    fill_in "Estado", with: @lic.estado
    fill_in "Usuario", with: @lic.usuario_id
    click_on "Create Lic"

    assert_text "Lic was successfully created"
    click_on "Back"
  end

  test "should update Lic" do
    visit lic_url(@lic)
    click_on "Edit this lic", match: :first

    fill_in "Descripcion", with: @lic.descripcion
    fill_in "Estado", with: @lic.estado
    fill_in "Usuario", with: @lic.usuario_id
    click_on "Update Lic"

    assert_text "Lic was successfully updated"
    click_on "Back"
  end

  test "should destroy Lic" do
    visit lic_url(@lic)
    click_on "Destroy this lic", match: :first

    assert_text "Lic was successfully destroyed"
  end
end
