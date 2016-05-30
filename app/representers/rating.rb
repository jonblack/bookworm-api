module Bookworm
  module Representers
    module Rating
      include Roar::JSON::HAL

      property :id
      property :score
      property :user_id

      link :self do |opts|
        "#{opts[:base_url]}/book/#{book_id}/rating/#{id}"
      end

      link :book do |opts|
        "#{opts[:base_url]}/book/#{book_id}"
      end

      link :user do |opts|
        "#{opts[:base_url]}/user/#{user_id}"
      end
    end
  end
end
