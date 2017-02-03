class Post < ApplicationRecord
  belongs_to :user
  validates :name, length: { minimum: 3 }, uniqueness: true
end
