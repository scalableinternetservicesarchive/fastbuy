require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '.entry', 3
    assert_select 'h3', 'Programming Ruby 1.9'
    assert_select '.price', /\$[,\d]+\.\d\d/
    assert_select '.quantity', /\d+/
    assert_select '.rating', /[,\d]+\.\d/
  end

  # Need Fixes Here
  test "markup needed for store.js.coffee is in place" do
    get :index
    assert_select '.store .entry > img', 3
  end

end
