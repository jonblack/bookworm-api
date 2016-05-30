module Bookworm
  module Representers
    module Books
      include Roar::JSON::HAL

      collection :books, class: Bookworm::Models::Book, extend: Bookworm::Representers::Book, embedded: true

      link :self do |opts|
        "#{opts[:base_url]}/books"
      end

      def books
        self
      end
    end
  end
end
