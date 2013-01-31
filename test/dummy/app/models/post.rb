class Post < ActiveRecord::Base
  attr_accessible :description, :tags, :title, :image
  has_attached_file :image
end
