# -*- coding: utf-8 -*-

#
# リレーションシップモデル
#
# - フォローするユーザーとフォローされるユーザーの関係を表す
#
# # 使い方
# ```
# ```
#
class Relationship < ActiveRecord::Base
  # @!group Relationships
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # @!endgroup

  # @!group Validations
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # @!endgroup
end
