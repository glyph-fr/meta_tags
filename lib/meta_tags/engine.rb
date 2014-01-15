require "meta_tags/container"
require "meta_tags/page_data_helper"
require "meta_tags/controller"
require "meta_tags/meta_taggable"
require "meta_tags/meta_taggable_macro"

module MetaTags
  class Railtie < Rails::Engine
    initializer "include controller config" do
      ActiveSupport.on_load(:action_controller) do
        include Controller
      end
    end

    initializer "mix meta_taggable macro in Active Record" do
      ActiveSupport.on_load(:active_record) do
        include MetaTaggableMacro
      end
    end
  end
end