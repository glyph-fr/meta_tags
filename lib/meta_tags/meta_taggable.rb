module MetaTags
  module MetaTaggable
    extend ActiveSupport::Concern

    included do
      has_one :meta_tags_list, class_name: "MetaTags::List",
        as: :meta_taggable, dependent: :destroy
      accepts_nested_attributes_for :meta_tags_list, allow_destroy: true,
        reject_if: :all_blank

      # Ensure nested form can be handled for Rails < 4
      if respond_to?(:protected_attributes)
        attr_accessible :meta_tags_list_attributes
      end
    end

    def meta_tagged?
      meta_tags_list.presence
    end
  end
end