module Bookworm
  module Controllers
    class Authors < Bookworm::App
      App.get '/authors/?' do
        authors = Bookworm::Models::Author.order(:name).all
        authors.extend(Bookworm::Representers::Authors)
        authors.to_json(base_url: request.base_url)
      end

      App.get '/author/:id/?' do
        @author.extend(Bookworm::Representers::Author)
        @author.to_json(base_url: request.base_url)
      end

      App.get '/author/:id/books/?' do
        books = @author.books
        books.extend(Bookworm::Representers::AuthorBooks)
        books.to_json(base_url: request.base_url, author_id: @author.id)
      end

      App.before '/author/:id*' do
        @author = Bookworm::Models::Author.find_by_id(params[:id])
        halt 404, json(message: 'Unknown author') unless @author
      end
    end
  end
end
