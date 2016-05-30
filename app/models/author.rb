module Bookworm
  module Models
    class Author < ActiveRecord::Base
      has_many :books

      validates :name, presence: true
    end
  end
end
