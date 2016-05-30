module Bookworm
  module Representers
    module UserRatings
      include Roar::JSON::HAL

      collection :ratings, class: Bookworm::Models::Rating, extend: Bookworm::Representers::Rating, embedded: true

      link :self do |opts|
        "#{opts[:base_url]}/user/#{opts[:user_id]}/ratings"
      end

      def ratings
        self
      end
    end
  end
end
