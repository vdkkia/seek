require 'jwt'

module Seek
  class JsonWebToken
    LEEWAY = 10.minutes

    def self.encode(payload, expires_at)
      payload[:exp] = (expires_at + LEEWAY).to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base, Seek::Config.jwt_algorithm)
    end

    def self.decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base, true,
                        { algorithm: Seek::Config.jwt_algorithm })[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError
      nil
    end
  end
end
