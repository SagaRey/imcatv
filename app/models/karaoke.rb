class Karaoke < ActiveRecord::Base
  mount_uploader :picture, PictureUploader
end
