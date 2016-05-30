module Bookworm
  module Representers
    module User
      include Roar::JSON::HAL

      property :id
      property :username
      property :auth_token, if: ->(opts) { opts[:auth_token] }

      link :self do |opts|
        "#{opts[:base_url]}/user/#{id}"
      end

      link :ratings do |opts|
        "#{opts[:base_url]}/user/#{id}/ratings"
      end
    end
  end
end
