# -*- coding: utf-8 -*-

#
# ユーザーモデル
#
# - システムのユーザーを表す
# - ユーザー情報と自身が登録したマイクロポストの一覧を保持する
#
# # 使い方
# ```
# user = User.new(
#   name: "Example User",
#   email: "user@example.com",
#   password: "foobar",
#   password_confirmation: "foobar"
# )
# ```
#
class User < ActiveRecord::Base

  #
  # @!attribute name
  #   @return [String] ユーザー名
  #
  # @!attribute email
  #   @return [String] メールアドレス
  #
  # @!attribute created_at
  #   @return [DateTime] 作成日時
  #
  # @!attribute updated_at
  #   @return [DateTime] 更新日時
  #
  # @!attribute password_digest
  #   @return [String] 暗号化されたパスワード（SHA1形式）
  #
  # @!attribute remember_token
  #   @return [String] 暗号化されたトークン（SHA1形式）
  #
  # @!attribute admin
  #   @return [Boolean] 管理者フラグ
  #

  # 正しいメールアドレスを表す正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  # @!group Relations
  has_many :microposts, dependent: :destroy
  # @!endgroup

  # @!group Before actions
  before_save { self.email = self.email.downcase }
  before_create :create_remember_token
  # @!endgroup

  # @!group Validations
  validates :name,  presence: true,
                    length: { maximum: 50 }
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  # @!endgroup

  #
  # ユーザーが登録したマイクロポストの一覧を返す
  #
  # @return [Array] ユーザーが登録したマイクロポストの一覧
  # @example
  # ```
  # feed = user.feed
  # ```
  #
  def feed
    Micropost.where("user_id = ?", id)
  end

  #
  # ログイン状態を管理するトークンを返す
  #
  # @return [String] ログイン状態を管理するトークン（Base64形式）
  # @example
  # ```
  # remember_token = User.new_remember_token
  # cookies.permanent[:remember_token] = remember_token
  # user.update_attribute(:remember_token, User.encrypt(remember_token))
  # self.current_user = user
  # ```
  #
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  #
  # 与えられたトークンを暗号化して返す
  #
  # @param [String] token トークン（Base64形式）
  # @return [String] 暗号化されたトークン（SHA1形式）
  # @example
  # ```
  # remember_token = User.new_remember_token
  # cookies.permanent[:remember_token] = remember_token
  # user.update_attribute(:remember_token, User.encrypt(remember_token))
  # self.current_user = user
  # ```
  #
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
