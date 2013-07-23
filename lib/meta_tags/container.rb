module MetaTags
  class Container
    attr_accessor :default_title, :default_description, :default_image,
     :default_url, :default_site_name, :default_keywords, :default_type,
     :title_changed, :description_changed, :image_changed, :url_changed,
     :site_name_changed, :keywords_changed, :type_changed, :site_changed,
     :default_site, :card_changed, :default_card, :default_publisher, :publisher_changed

    TAGS_LIST = %w(
      title description image url site_name keywords type site card publisher
    )

    TAGS_LIST.each do |label|
      class_eval <<-CLASS
        def #{ label }
          tag = @#{ label } || default_#{ label }
          tag && Sanitize.clean(tag)
        end

        def #{ label }=(value)
          @#{ label }_changed = true
          @#{ label } = value
        end

        def #{ label }_changed?
          !!@#{ label }_changed
        end
      CLASS
    end

    def initialize options
      options.each do |label, value|
        self.send("default_#{ label }=", value)
      end
    end

    def title=(value)
      @title_changed = true
      if default_title == value
        @title = default_title
      else
        @title = "#{ value } - #{ default_title }"
      end
    end


    def reset_changed_status
      TAGS_LIST.each do |label|
        self.send("#{ label }_changed=", false)
      end
    end
  end
end