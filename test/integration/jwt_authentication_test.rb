require 'test_helper'

class JWTAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = Factory(:person, first_name: 'John', last_name: 'Smith').user
  end

  test 'can authenticate with valid token' do
    token = Seek::JsonWebToken.encode({ user_id: @user.id }, 2.days.from_now.to_i)

    get me_people_path, headers: { 'Authorization' => "Bearer #{token}" }

    assert_redirected_to person_path(@user.person)
    follow_redirect!
    assert_select '#user-menu-button span.truncated-name', text: 'John Smith', count: 1
  end

  test 'cannot authenticate with a bad token' do
    token = Seek::JsonWebToken.encode({ user_id: @user.id }, 2.days.from_now.to_i)
    token.reverse!

    get me_people_path, headers: { 'Authorization' => "Bearer #{token}" }

    assert_redirected_to root_path
    follow_redirect!
    assert_select '#user-menu-button span.truncated-name', text: 'John Smith', count: 0
  end

  test 'cannot authenticate with a bad auth type' do
    token = Seek::JsonWebToken.encode({ user_id: @user.id }, 2.days.from_now.to_i)

    get me_people_path, headers: { 'Authorization' => "Tigerer #{token}" }

    assert_redirected_to root_path
    follow_redirect!
    assert_select '#user-menu-button span.truncated-name', text: 'John Smith', count: 0
  end

  test 'cannot authenticate with an expired token' do
    token = Seek::JsonWebToken.encode({ user_id: @user.id }, 2.days.ago.to_i)

    get me_people_path, headers: { 'Authorization' => "Bearer #{token}" }

    assert_redirected_to root_path
    follow_redirect!
    assert_select '#user-menu-button span.truncated-name', text: 'John Smith', count: 0
  end
end
