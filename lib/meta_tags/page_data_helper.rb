module MetaTags
  module PageDataHelper
    def process_title
      if member_action? && instance.respond_to?(:title)
        return instance.title
      end

      if (action_name = action_i18n(:title))
        return action_name
      end

      if (translation = I18n.t("active_record.models.#{ self.class.model_name }", default: "").presence)
        return translation.pluralize if translation
      end
    end

    def process_description
      if member_action? && instance.respond_to?(:description)
        return instance.description
      end

      if (action_name = action_i18n(:description))
        return action_name
      end
    end

    def process_image
      if member_action? && instance.respond_to?(:description)
        return instance.image.url
      end
      return meta_tags_container.default_image
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

    def process_meta_tags
      if params[:id]
        
        %w(title description image).each do |label|
          if instance.respond_to? label
            value = label == "image" ? instance.send(label).url : instance.send(label)
            set_meta_tag label, value unless meta_tags_container.send("#{ label }_changed?")
          end
        end
      else
        %w(title description).each do |label|
          unless meta_tags_container.send("#{label}_changed?")
            translation = 
            
            if label == 'title' && !translation
              translation = I18n.t("active_record.models.#{ self.class.model_name }", default: "").presence
              translation.pluralize if translation
            end

            set_meta_tag label, translation if translation
          end
        end
        
        set_meta_tag :image, meta_tags_container.default_image unless meta_tags_container.image_changed?
      end
    end

  end
end