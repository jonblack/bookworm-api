module Bookworm
  module Controllers
    class Users < Bookworm::App
      App.get '/users/?' do
        users = Bookworm::Models::User.order(:username).all
        users.extend(Bookworm::Representers::Users)
        users.to_json(base_url: request.base_url)
      end

      App.post '/users/login/?' do
        user = Bookworm::Models::User.find_by(username: params['username'])
        halt 400, json(message: 'Unknown username') unless user
        halt 401, json(message: 'Incorrect password') unless user.authenticate!(params['password'])

        # Generate a new auth_token
        user.set_auth_token
        user.save

        user.extend(Bookworm::Representers::User)
        user.to_json(base_url: request.base_url, auth_token: true)
      end

      App.post '/users/logout/?' do
        require_auth

        current_user.auth_token = ''
        current_user.save

        current_user.extend(Bookworm::Representers::User)
        current_user.to_json(base_url: request.base_url, auth_token: true)
      end

      App.post '/users/signup/?' do
        begin
          user = Bookworm::Models::User.create!(
            username: params['username'],
            password: params['password']
          )
        rescue ActiveRecord::RecordInvalid => e
          halt 400, json(message: e.message)
        end

        user.extend(Bookworm::Representers::User)
        user.to_json(base_url: request.base_url, auth_token: true)
      end

      App.get '/user/:id/?' do
        @user.extend(Bookworm::Representers::User)
        @user.to_json(base_url: request.base_url, auth_token: false)
      end

      App.get '/user/:id/ratings/?' do
        ratings = @user.ratings
        ratings.extend(Bookworm::Representers::UserRatings)
        ratings.to_json(base_url: request.base_url, user_id: @user.id)
      end

      App.before '/user/:id*' do
        @user = Bookworm::Models::User.find_by_id(params[:id])
        halt 404, json(message: 'Unknown user') unless @user
      end
    end
  end
end
