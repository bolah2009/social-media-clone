# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::ControllerHelpers


  test 'logged in should get index' do
    sign_in users(:one)
    get :index
    assert_response :success
  end

  test 'not authenticated should get redirect' do
    get :index
    assert_response :redirect
  end
end
