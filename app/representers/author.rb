module Bookworm
  module Representers
    module Author
      include Roar::JSON::HAL

      property :id
      property :name

      link :self do |opts|
        "#{opts[:base_url]}/author/#{id}"
      end

      link :books do |opts|
        "#{opts[:base_url]}/author/#{id}/books"
      end
    end
  end
end
