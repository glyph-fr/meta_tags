module MetaTags
  module Tags
    class Title < Base
      def process!
        meta_taggable_title || instance_title || action_name || model_name_translation
      end

      private

      def meta_taggable_title
        instance && instance.meta_tagged? &&
          instance.meta_tags_list.meta_title.presence
      end

      def instance_title
        if instance
          MetaTags.title_methods.each do |method|
            if instance.respond_to?(method) && (title = instance.send(method)).presence
              return title
            end
          end
          return nil
        end
      end

      def action_name
        if (action_name = action_i18n(:title))
          return action_name
        end
      end

      def model_name_translation
        return unless model_name
        model_key = "activerecord.models.#{ model_name }"

        if (translation = I18n.t("#{ model_key }.other", default: "").presence)
          translation
        elsif (translation = I18n.t(model_key, default: "").presence)
          translation.pluralize
        end
      end
    end
  end
end