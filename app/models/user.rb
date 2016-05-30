module Bookworm
  module Models
    class User < ActiveRecord::Base
      has_many :ratings

      validates :username, :password, presence: true
      validates :username, uniqueness: true
      validates :password, length: { minimum: 8 }

      before_create :set_auth_token
      before_save :hash_password

      def set_auth_token
        return unless auth_token == '' || auth_token.nil?
        self.auth_token = SecureRandom.uuid.delete('-')
      end

      def hash_password
        return unless password_changed?
        self.password = BCrypt::Password.create(password)
      end

      def authenticate!(password)
        BCrypt::Password.new(self.password) == password
      end
    end
  end
end
