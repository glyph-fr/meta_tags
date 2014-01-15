module MetaTags
  module Tags
    class Keywords < Base
      def process!
        meta_taggable_keywords
      end

      private

      def meta_taggable_keywords
        instance && instance.meta_tags_list &&
          instance.meta_tags_list.meta_keywords.presence
      end
    end
  end
end