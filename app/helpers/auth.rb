module Sinatra
  module Auth
    def current_user
      auth_token = env['HTTP_AUTHORIZATION'].to_s
      @current_user ||= Bookworm::Models::User.find_by(auth_token: auth_token)

      return nil unless @current_user

      @current_user
    end

    def require_auth
      halt 401, json(message: 'Authorization required') unless current_user
    end
  end
end
