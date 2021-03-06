module MetaTags
  module Tags
    class Keywords < Base
      def value
        meta_taggable_keywords
      end

      private

      def meta_taggable_keywords
        instance && instance.meta_tagged? &&
          instance.meta_tags_list.meta_keywords.presence
      end
    end
  end
end
