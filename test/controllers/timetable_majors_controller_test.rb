require 'test_helper'

class TimetableMajorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timetable_major = timetable_majors(:one)
  end

  test "should get index" do
    get timetable_majors_url
    assert_response :success
  end

  test "should get new" do
    get new_timetable_major_url
    assert_response :success
  end

  test "should create timetable_major" do
    assert_difference('TimetableMajor.count') do
      post timetable_majors_url, params: { timetable_major: {  } }
    end

    assert_redirected_to timetable_major_url(TimetableMajor.last)
  end

  test "should show timetable_major" do
    get timetable_major_url(@timetable_major)
    assert_response :success
  end

  test "should get edit" do
    get edit_timetable_major_url(@timetable_major)
    assert_response :success
  end

  test "should update timetable_major" do
    patch timetable_major_url(@timetable_major), params: { timetable_major: {  } }
    assert_redirected_to timetable_major_url(@timetable_major)
  end

  test "should destroy timetable_major" do
    assert_difference('TimetableMajor.count', -1) do
      delete timetable_major_url(@timetable_major)
    end

    assert_redirected_to timetable_majors_url
  end
end
