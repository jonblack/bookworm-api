module Bookworm
  module Controllers
    class Api < Bookworm::App
      App.get '/api/?' do
        Object.new.extend(Bookworm::Representers::Api).to_json(base_url: request.base_url)
      end
    end
  end
end
