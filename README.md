`bookworm-api` is a HAL API for booklovers that allows users to rate
books they've read.

There are four resources:

1. Author
2. Book
3. Rating
4. User

Unauthenticated users can view information about all entities; authenticated
users can rate books.

[`bookworm-client`](http://github.com/jonblack/bookworm-client) is a frontend
web application that implements this API.

# Requirements

* ruby
* bundler
* postgres

# Run

Install the dependencies with:

    bundle install

Setup the user in postgres:

    CREATE USER bookworm WITH PASSWORD 'bookworm';
    ALTER USER bookworm CREATEDB;

Create the database and tables:

    rake db:create
    rake db:migrate
    rake db:create RACK_ENV=test
    rake db:migrate RACK_ENV=test
    rake db:create RACK_ENV=development
    rake db:migrate RACK_ENV=development

Load example data:

    psql -h localhost -d bookworm_production -U bookworm -W -a -f test_data.sql
    psql -h localhost -d bookworm_development -U bookworm -W -a -f test_data.sql

And run the application:

    rerun -- rackup -s Puma

# Test

The tests have been written using cucumber and can be run with the command:

    cucumber -m

There are 23 tests comprised of 122 steps.

# Rubocop

Static analysis can be run with rubocop:

    rubocop

It uses the same settings as in
[blendle/blendle-styleguides](https://github.com/blendle/blendle-styleguides).

# API

* GET /api

* GET /users
* POST /users/login
* POST /users/logout (requires authentication)
* POST /users/signup
* GET /user/:id
* GET /user/:id/ratings

* GET /authors
* GET /author/:id
* GET /author/:id/books

* GET /books
* GET /book/:id
* GET /book/:id/ratings
* POST /book/:id/ratings (requires authentication)

# Wishlist

* Dockerfile using the blendle/ruby image
* Documentation generated from the cucumber feature tests
* Documentation links in the form of HAL CURIES
* Pagination
* The regex checker error message in features can be hard to parse for large
  json documents. A better approach might have been to provide more fine
  grained steps for checking the content of individual HAL+JSON elements.
