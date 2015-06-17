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

    def meta_tags_from(resource)
      @instance = resource
    end

    def set_meta_tags_from_list(list)
      if list.kind_of?(MetaTags::List)
        [:title, :description, :keywords].each do |tag_name|
          if (value = list.send(:"meta_#{ tag_name }")).present?
            set_meta_tag(tag_name, value)
          end
        end
      else
        list = MetaTags::List.where(identifier: list.to_s).first
        set_meta_tags_from_list(list) if list
      end
    end

    def set_meta_tag(tag_name, value)
      meta_tags_store.send(:"#{ tag_name }=", value)
    end
  end
end
