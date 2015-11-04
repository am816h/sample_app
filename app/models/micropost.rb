# -*- coding: utf-8 -*-

#
# マイクロポストモデル
#
# - ユーザーが登録したマイクロポストを表す
# - マイクロポストは最大140文字とする
#
# # 使い方
# ```
# micropost = Micropost.new(
#   content: "foobar",
#   user_id: User.find(1).id
# )
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
end
