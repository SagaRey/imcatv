class Program < ActiveRecord::Base
  validates :datatime, presence: true
  validates :content, presence: true
end
