require 'test_helper'

class TimetableNormalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timetable_normal = timetable_normals(:one)
  end

  test "should get index" do
    get timetable_normals_url
    assert_response :success
  end

  test "should get new" do
    get new_timetable_normal_url
    assert_response :success
  end

  test "should create timetable_normal" do
    assert_difference('TimetableNormal.count') do
      post timetable_normals_url, params: { timetable_normal: {  } }
    end

    assert_redirected_to timetable_normal_url(TimetableNormal.last)
  end

  test "should show timetable_normal" do
    get timetable_normal_url(@timetable_normal)
    assert_response :success
  end

  test "should get edit" do
    get edit_timetable_normal_url(@timetable_normal)
    assert_response :success
  end

  test "should update timetable_normal" do
    patch timetable_normal_url(@timetable_normal), params: { timetable_normal: {  } }
    assert_redirected_to timetable_normal_url(@timetable_normal)
  end

  test "should destroy timetable_normal" do
    assert_difference('TimetableNormal.count', -1) do
      delete timetable_normal_url(@timetable_normal)
    end

    assert_redirected_to timetable_normals_url
  end
end
