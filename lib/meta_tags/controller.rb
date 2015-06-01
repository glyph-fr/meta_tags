module MetaTags
  module Controller
    extend ActiveSupport::Concern

    included do
      helper_method :meta_tags_store
    end

    def meta_tags_store
      @meta_tags_store ||= MetaTags::Store.new(self)
    end

    protected

    def meta_tags_for(identifier)
      if identifier.kind_of?(ActiveRecord::Base)
        @instance = identifier
      elsif (list = MetaTags::List.where(identifier: identifier.to_s).first)
        [:title, :description, :keywords].each do |tag_name|
          if (value = list.send(:"meta_#{ tag_name }").presence)
            set_meta_tag(tag_name, value)
          end
        end
      end
    end

    def set_meta_tag(tag_name, value)
      meta_tags_store.send(:"#{ tag_name }=", value)
    end
  end
end
