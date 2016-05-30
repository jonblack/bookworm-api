module Bookworm
  module Models
    class Book < ActiveRecord::Base
      has_many :ratings
      belongs_to :author

      validates :title, :year_published, presence: true
      validates :year_published, numericality: {
        only_integer: true,
        greater_than: 0
      }
    end
  end
end
