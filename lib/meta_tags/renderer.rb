module MetaTags
  class Renderer
    LINE_SEPARATOR = "\n"

    attr_reader :template, :vendors

    delegate :content_tag, :tag, to: :template

    def initialize(template, vendors: nil)
      @template = template
      @vendors = vendors
    end

    def render
      [
        charset_tag,
        title_tag,
        description_tag,
        keywords_tag,
        vendor_tags
      ].compact.join(LINE_SEPARATOR).html_safe
    end

    private

    def title_tag
      if (title = meta_tags.title).present?
        content_tag(:title, title)
      end
    end

    def charset_tag
      tag(:meta, charset: meta_tags.charset)
    end

    def description_tag
      if (description = meta_tags.description).present?
        tag(:meta, name: 'description', value: description)
      end
    end

    def keywords_tag
      if (keywords = meta_tags.keywords).present?
        tag(:meta, name: 'keywords', value: keywords)
      end
    end

    def vendor_tags
      return unless vendors

      vendor_tags = vendors.each_with_object([]) do |vendor_name, tags|
        vendor_class = MetaTags::Vendors.for(vendor_name)
        vendor = vendor_class.new(template)

        vendor.tags.each do |tag_name|
          if (value = meta_tags.send(tag_name)).present?
            tags << vendor.render(tag_name, value)
          end
        end
      end

      vendor_tags.join(LINE_SEPARATOR)
    end

    def meta_tags
      @meta_tags ||= template.controller.meta_tags_store
    end
  end
end
