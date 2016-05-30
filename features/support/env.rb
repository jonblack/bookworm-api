ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app.rb')
require 'rack/test'
require 'rspec/expectations'

module AppHelper
  def app
    Bookworm::App
  end
end

World(Rack::Test::Methods, AppHelper)
