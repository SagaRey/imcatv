class News < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :content, presence: true
  # default_scope -> { order(created_at: :desc) }
end