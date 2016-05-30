require_relative '../../app/models/author'
require_relative '../../app/models/book'
require_relative '../../app/models/rating'
require_relative '../../app/models/user'

Given(/^the system knows about the following authors:$/) do |authors|
  authors.hashes.each do |author|
    Bookworm::Models::Author.create(
      id: author['id'],
      name: author['name']
    )
  end
end

Given(/^the system knows about the following books:$/) do |books|
  books.hashes.each do |book|
    Bookworm::Models::Book.create(
      id: book['id'],
      title: book['title'],
      year_published: book['year_published'],
      author_id: book['author_id']
    )
  end
end

Given(/^the system knows about the following users:$/) do |users|
  users.hashes.each do |user|
    Bookworm::Models::User.create(
      id: user['id'],
      username: user['username'],
      password: user['password']
    )
  end
end

Given(/^the system knows about the following ratings:$/) do |ratings|
  ratings.hashes.each do |rating|
    Bookworm::Models::Rating.create(
      id: rating['id'],
      score: Integer(rating['score']),
      user_id: rating['user_id'],
      book_id: rating['book_id']
    )
  end
end
