module MetaTags
  module MetaTaggableMacro
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_meta_taggable
        include MetaTaggable
      end
    end

    def meta_tagged?
      false
    end
  end
end