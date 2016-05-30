When(/^the client requests GET (.+)$/) do |endpoint|
  get endpoint
end

When(/^the client requests POST (.+) with:$/) do |endpoint, params|
  # Check if the last call to this method was to log the user in, and if so,
  # extract the auth_token and set it in the header for the current request.
  begin
    res = JSON.parse(last_response.body)
    header 'Authorization', res['auth_token'] if res.key?('auth_token')
  rescue Rack::Test::Error # rubocop:disable Lint/HandleExceptions
  end

  # Parse and dump to get a hash of the params
  post endpoint, JSON.dump(JSON.parse(params))
end

Then(/^the response Content-Type must be (.+)$/) do |content_type|
  expect(last_response.header['Content-Type']).to include(content_type)
end

Then(/^the response contains:$/) do |json|
  # Parse the JSON strings and dump again to remove whitespace so comparisons
  # are straightforward
  res_str = StringIO.new
  JSON.dump(JSON.parse(last_response.body), res_str)
  exp_str = StringIO.new
  JSON.dump(JSON.parse(json), exp_str)

  # Compare using regular expression. This means you can put regular
  # expressions in the json in your tests.
  expect(res_str.string).to match(exp_str.string)
end

Then(/^the response status code is (\d{3})$/) do |status_code|
  expect(last_response.status).to eq(Integer(status_code))
end
