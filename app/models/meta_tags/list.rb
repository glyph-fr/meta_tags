module MetaTags
  class List < ActiveRecord::Base
    if respond_to?(:protected_attributes)
      attr_accessible :name, :identifier, :meta_taggable_id,
        :meta_taggable_type, :meta_title, :meta_description, :meta_keywords
    end

    belongs_to :meta_taggable, polymorphic: true

    validates_presence_of :name, :identifier, unless: :meta_taggable
  end
end