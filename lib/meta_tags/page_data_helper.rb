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

    def process_type

    end

    def process_site_name

    end

    def process_site

    end

    def process_card

    end

    def process_keywords

    end

    private

    def member_action?
      !!params[:id]
    end

    def action_i18n(label)
      I18n.t("meta_tags.controller.#{ params[:controller] }.#{ params[:action] }.#{label}", default: "").presence
    end

    def instance
      @instance ||= self.instance_variable_get "@#{ self.class.model_name }"
    end
  end
end