module MetaTags
  class Railtie < Rails::Engine
    initializer "include controller helpers" do
      ActiveSupport.on_load(:action_controller) do
        include Controller
      end
    end

    initializer "include view helpers" do
      ActiveSupport.on_load(:action_view) do
        include ViewHelpers
      end
    end

    initializer "mix meta_taggable macro in Active Record" do
      ActiveSupport.on_load(:active_record) do
        include MetaTaggableMacro
      end
    end
  end
end
