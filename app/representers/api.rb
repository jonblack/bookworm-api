module Bookworm
  module Representers
    module Api
      include Roar::JSON::HAL

      link :self do |opts|
        opts[:base_url].to_s
      end

      link :authors do |opts|
        "#{opts[:base_url]}/authors"
      end

      link :author do |opts|
        {
          href: "#{opts[:base_url]}/author/{id}",
          templated: true
        }
      end

      link :books do |opts|
        "#{opts[:base_url]}/books"
      end

      link :book do |opts|
        {
          href: "#{opts[:base_url]}/book/{id}",
          templated: true
        }
      end

      link :user do |opts|
        {
          href: "#{opts[:base_url]}/user/{id}",
          templated: true
        }
      end

      link :signup do |opts|
        "#{opts[:base_url]}/users/signup"
      end

      link :login do |opts|
        "#{opts[:base_url]}/users/login"
      end

      link :logout do |opts|
        "#{opts[:base_url]}/users/logout"
      end
    end
  end
end
