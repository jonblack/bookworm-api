module Bookworm
  module Controllers
    class Books < Bookworm::App
      App.get '/books/?' do
        books = Bookworm::Models::Book.order(:title).all
        books.extend(Bookworm::Representers::Books)
        books.to_json(base_url: request.base_url)
      end

      App.get '/book/:id/?' do
        @book.extend(Bookworm::Representers::Book)
        @book.to_json(base_url: request.base_url)
      end

      App.get '/book/:id/ratings/?' do
        ratings = @book.ratings
        ratings.extend(Bookworm::Representers::BookRatings)
        ratings.to_json(base_url: request.base_url, book_id: @book.id)
      end

      App.post '/book/:id/ratings/?' do
        require_auth

        r = Bookworm::Models::Rating.where('book_id = ? AND user_id = ?', @book.id, current_user.id).first
        if r
          halt 400, json(message: 'This book has already been rated by this user')
        end

        begin
          rating = Bookworm::Models::Rating.create!(
            score: params['score'],
            book_id: @book.id,
            user_id: current_user.id
          )
        rescue ActiveRecord::RecordInvalid => e
          halt 400, json(message: e.message)
        end

        rating.extend(Bookworm::Representers::Rating)
        rating.to_json(base_url: request.base_url)
      end

      App.before '/book/:id*' do
        @book = Bookworm::Models::Book.find_by_id(params[:id])
        halt 404, json(message: 'Unknown book') unless @book
      end
    end
  end
end
