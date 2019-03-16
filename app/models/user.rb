class User < ApplicationRecord
    attr_accessor :remember_token
    before_save {self.email = email.downcase}
    validates :name, presence: true, length: {maximum:50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,presence: true, length: {maximum:100}, format: { with: VALID_EMAIL_REGEX},
              uniqueness: {case_sensitive: false}
    has_secure_password
    validates :password, presence: true, length: {minimum:6}

    def User.digest(string)
        #ハッシュ値を返す
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        #ハッシュ値でパスワードを登録する
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecurePassword.urlsafe_base64

    def remember
        self.remember = User.new_token
        update_attribute(:remember_token, User.digest(remember_token))
end
