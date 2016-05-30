module Bookworm
  module Representers
    module Book
      include Roar::JSON::HAL

      property :id
      property :title
      property :year_published

      link :self do |opts|
        "#{opts[:base_url]}/book/#{id}"
      end

      link :ratings do |opts|
        "#{opts[:base_url]}/book/#{id}/ratings"
      end
    end
  end
end
