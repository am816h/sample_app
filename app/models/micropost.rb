# -*- coding: utf-8 -*-

#
# マイクロポストモデル
#
# - ユーザーが登録したマイクロポストを表す
# - マイクロポストは最大140文字とする
#
# # 使い方
# ```
# user = User.new(...)
# micropost = user.microposts.build(content: "foobar")
# ```
#
class Micropost < ActiveRecord::Base

  #
  # @!attribute content
  #   @return [String] 内容
  #
  # @!attribute user_id
  #   @return [Integer] ユーザーID
  #
  # @!attribute created_at
  #   @return [DateTime] 作成日時
  #
  # @!attribute updated_at
  #   @return [DateTime] 更新日時
  #

  # @!group Relations
  belongs_to :user
  # @!endgroup

  # @!group Scopes
  default_scope -> { order('created_at DESC') }
  # @!endgroup

  # @!group Validations
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  # @!endgroup

  #
  # 与えられたユーザーがフォローしているユーザーのマイクロポスト一覧を返す。
  #
  # @param [User] ユーザー
  # @return [Array] 与えられたユーザーがフォローしているユーザーのマイクロポスト一覧
  # @example
  # ```
  #
  # ```
  #
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user)
  end
end
