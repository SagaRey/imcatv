class Comment < ActiveRecord::Base
  belongs_to :news
  validates :commenter, presence: true
  validates :body, presence: true
end
