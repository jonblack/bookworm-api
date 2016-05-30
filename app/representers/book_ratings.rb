module Bookworm
  module Representers
    module BookRatings
      include Roar::JSON::HAL

      collection :ratings, class: Bookworm::Models::Rating, extend: Bookworm::Representers::Rating, embedded: true

      link :self do |opts|
        "#{opts[:base_url]}/book/#{opts[:book_id]}/ratings"
      end

      def ratings
        self
      end
    end
  end
end
