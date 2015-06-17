module MetaTags
  module MetaTaggableMacro
    extend ActiveSupport::Concern

    def meta_tagged?
      false
    end

    module ClassMethods
      def acts_as_meta_taggable
        include MetaTaggable
      end

      def meta_taggable?
        false
      end
    end
  end
end
