require "truncate_html"

module MetaTags
  module Tags
    class Description < Base
      include TruncateHtmlHelper

      def process!
        meta_taggable_description || instance_description || action_name
      end

      private

      def meta_taggable_description
        instance && instance.meta_tagged? &&
          instance.meta_tags_list.meta_description.presence
      end

      def instance_description
        if instance
          MetaTags.description_methods.each do |method|
            if instance.respond_to?(method)
              if (description = instance.send(method).presence)
                return truncate_html(description, length: 250)
              end
            end
          end

          return nil
        end
      end

      def action_name
        if (action_name = action_i18n(:description))
          return action_name
        end
      end
    end
  end
end