require "application_system_test_case"

class IncidencesTest < ApplicationSystemTestCase
  setup do
    @incidence = incidences(:one)
  end

  test "visiting the index" do
    visit incidences_url
    assert_selector "h1", text: "Incidences"
  end

  test "should create incidence" do
    visit incidences_url
    click_on "New incidence"

    fill_in "Auto", with: @incidence.auto_id
    fill_in "Descripcion", with: @incidence.descripcion
    click_on "Create Incidence"

    assert_text "Incidence was successfully created"
    click_on "Back"
  end

  test "should update Incidence" do
    visit incidence_url(@incidence)
    click_on "Edit this incidence", match: :first

    fill_in "Auto", with: @incidence.auto_id
    fill_in "Descripcion", with: @incidence.descripcion
    click_on "Update Incidence"

    assert_text "Incidence was successfully updated"
    click_on "Back"
  end

  test "should destroy Incidence" do
    visit incidence_url(@incidence)
    click_on "Destroy this incidence", match: :first

    assert_text "Incidence was successfully destroyed"
  end
end
