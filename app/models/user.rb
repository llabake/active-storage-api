# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar
  validates :username, presence: true
  validate :avatar_present?

  private

  def avatar_present?
    errors.add(:avatar, :blank) unless avatar.attached?
  end
end
