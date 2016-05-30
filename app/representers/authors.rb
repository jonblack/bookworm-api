module Bookworm
  module Representers
    module Authors
      include Roar::JSON::HAL

      collection :authors, class: Bookworm::Models::Author, extend: Bookworm::Representers::Author, embedded: true

      link :self do |opts|
        "#{opts[:base_url]}/authors"
      end

      def authors
        self
      end
    end
  end
end
