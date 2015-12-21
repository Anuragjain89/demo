class Product < ActiveRecord::Base
  include PublicActivity::Common
  mount_uploader :video, VideoUploader
  process_in_background :video
end
