require 'jwt'

module Seek
  class JsonWebToken
    LEEWAY = 10.minutes

    def self.encode(payload, expires_at)
      payload[:exp] = (expires_at + LEEWAY).to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def self.decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new(body)
    rescue
      nil
    end
  end
end
