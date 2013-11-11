module MetaTags
  module PageDataHelper
    def process_title
      if member_action?
        MetaTags.title_methods.each do |method|
          return instance.send(method) if instance.respond_to?(method)
        end
      end

      if (action_name = action_i18n(:title))
        return action_name
      end

      if self.class.model_name
        model_key = "activerecord.models.#{ self.class.model_name }"
        if (translation = I18n.t("#{ model_key }.other", default: "").presence)
          return translation
        elsif (translation = I18n.t(model_key, default: "").presence)
          return translation.pluralize
        end
      end
    end

    def process_description
      if member_action?
        MetaTags.description_methods.each do |method|
          return instance.send(method) if instance.respond_to?(method)
        end
      end

      if (action_name = action_i18n(:description))
        return action_name
      end
    end

    def process_image
      if member_action?
        MetaTags.image_methods.each do |method|
          return instance.send(method).url if instance.respond_to?(method) && instance.send(method)
        end
      end

      return meta_tags_container.default_image
    end

    def process_url
      @url = "#{request.original_url}"
    end

    %w(
      process_type process_site_name process_site process_card
      process_keywords process_publisher
    ).each do |method|
      define_method(method) do; end
    end

    private

    def member_action?
      !!params[:id]
    end

    def action_i18n label
      options = modifier_options.merge(default: "")
      I18n.t(action_key(label), options).presence
    end

    def action_key label
      key = %w(meta_tags controller)
      key << params[:controller]
      key << params[:action]
      key << label
      key.join(".")
    end

    def instance
      @instance ||= if self.class.model_name.presence
        self.instance_variable_get("@#{ self.class.model_name }")
      end
    end

    def modifier_options
      @modifier_options ||= begin
        if self.class.modifier_block
          instance_eval(&self.class.modifier_block)
        else
          {}
        end
      end
    end
  end
end