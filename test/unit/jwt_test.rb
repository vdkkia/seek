require 'test_helper'

class JWTTest < ActiveSupport::TestCase
  test 'can encode and decode tokens' do
    token = Seek::JsonWebToken.encode({ test: '123' }, Seek::Config.jwt_expiration.hours.from_now)
    assert_equal 3, token.split(".").length
    decoded_token = Seek::JsonWebToken.decode(token)
    assert_equal '123', decoded_token[:test]
  end

  test 'can expire tokens' do
    token = Seek::JsonWebToken.encode({ test: '123' }, 5.hours.ago)
    decoded_token = Seek::JsonWebToken.decode(token)
    assert_nil decoded_token
  end

  test 'can encode and decode tokens with different hash algorithms' do
    expiry = Seek::Config.jwt_expiration.hours.from_now

    assert_equal 'HS256', Seek::Config.jwt_algorithm

    hs256token = Seek::JsonWebToken.encode({ test: '123' }, expiry)
    assert_equal 3, hs256token.split(".").length
    decoded_hs256token = Seek::JsonWebToken.decode(hs256token)
    assert_equal '123', decoded_hs256token[:test]

    hs512token = nil
    with_config_value(:jwt_algorithm, 'HS512') do
      hs512token = Seek::JsonWebToken.encode({ test: '123' }, expiry)
      assert_equal 3, hs512token.split(".").length
      assert hs512token.length > hs256token.length
      decoded_hs512token = Seek::JsonWebToken.decode(hs512token)
      assert_equal '123', decoded_hs512token[:test]
    end

    assert_nil Seek::JsonWebToken.decode(hs512token), 'cannot decode HS512 token with HS256 algorithm'
  end

end
