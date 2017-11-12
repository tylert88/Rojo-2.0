require 'test_helper'

class ParkingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parking_index_url
    assert_response :success
  end

  test "should get new" do
    get parking_new_url
    assert_response :success
  end

  test "should get create" do
    get parking_create_url
    assert_response :success
  end

  test "should get listing" do
    get parking_listing_url
    assert_response :success
  end

  test "should get pricing" do
    get parking_pricing_url
    assert_response :success
  end

  test "should get description" do
    get parking_description_url
    assert_response :success
  end

  test "should get photo_upload" do
    get parking_photo_upload_url
    assert_response :success
  end

  test "should get amenities" do
    get parking_amenities_url
    assert_response :success
  end

  test "should get location" do
    get parking_location_url
    assert_response :success
  end

  test "should get update" do
    get parking_update_url
    assert_response :success
  end

end
