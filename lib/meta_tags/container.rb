require "sanitize"

module MetaTags
  class Container
    attr_accessor :default_title,
                  :default_description,
                  :default_image,
                  :default_url,
                  :default_site_name,
                  :default_keywords,
                  :default_type,
                  :default_site,
                  :default_card,
                  :title_changed,
                  :description_changed,
                  :image_changed,
                  :url_changed,
                  :site_name_changed,
                  :keywords_changed,
                  :type_changed,
                  :site_changed,
                  :card_changed

    TAGS_LIST = %w(
      title description image url site_name keywords type site card
    )

    TAGS_LIST.each do |label|
      define_method(label) do
        Sanitize.clean(
          instance_variable_get(:"@#{ label }") || send(:"default_#{ label }")
        ).gsub("\"", "&quot;")
      end

      define_method(:"#{ label }=") do |value|
        instance_variable_set(:"@#{ label }_changed", true)
        instance_variable_set(:"@#{ label }", value)
      end

      define_method(:"#{ label }_changed?") do
        !!instance_variable_get(:"@#{ label }_changed")
      end
    end

    def initialize options
      options.each do |label, value|
        self.send(:"default_#{ label }=", value)
      end
    end

    def title=(value)
      @title_changed = true
      if default_title == value || !MetaTags.keep_default_title_present
        @title = value
      elsif MetaTags.keep_default_title_present
        @title = "#{ value } #{ MetaTags.separator } #{ default_title }"
      end
    end


    def reset_changed_status
      TAGS_LIST.each do |label|
        self.send(:"#{ label }_changed=", false)
      end
    end
  end
end
