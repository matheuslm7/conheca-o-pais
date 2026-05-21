# frozen_string_literal: true

module AuthHelpers
  DEFAULT_PASSWORD = "Senha123!"

  def auth_headers_for(user, _password: DEFAULT_PASSWORD)
    token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)

    { "Authorization" => "Bearer #{token}" }
  end
end
