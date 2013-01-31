require 'meta_tags/container'
require 'meta_tags/page_data_helper'
require 'meta_tags/controller'


module MetaTags
  ActionController::Base.send(:include, Controller)
end


