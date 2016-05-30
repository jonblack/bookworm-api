module Bookworm
  module Models
    class Rating < ActiveRecord::Base
      belongs_to :user
      belongs_to :book

      validates :score, presence: true
      validates :score, numericality: {
        only_integer: true,
        greater_than_or_equal_to: 1,
        less_than_or_equal_to: 5,
        message: 'must be between 1 and 5'
      }
    end
  end
end
