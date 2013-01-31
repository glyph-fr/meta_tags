class Post < ActiveRecord::Base
  attr_accessible :description, :tags, :title
end
