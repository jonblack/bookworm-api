require 'rubygems'
require 'bundler'

Bundler.require

require 'roar/json/hal'
require 'sinatra/base'
require 'sinatra/activerecord'

require_relative 'app/helpers/auth'

module Bookworm
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    configure do
      set :bind, '0.0.0.0'
    end

    helpers do
      include Sinatra::Auth
    end

    before do
      content_type 'application/hal+json'

      # Parse json request params into a hash and merge
      hash = env['rack.input'].read
      params.merge!(JSON.parse(hash)) unless hash.blank?
    end

    # Load app files
    Dir['./app/models/*.rb'].each { |file| require file }
    Dir['./app/controllers/*.rb'].each { |file| require file }
    Dir['./app/representers/*.rb'].each { |file| require file }
  end
end
