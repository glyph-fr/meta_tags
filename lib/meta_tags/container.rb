module MetaTags
  class Container
    attr_accessor :default_title, :default_description, :default_image, :default_url, :default_site_name, :default_keywords, :default_type,
     :title_changed, :description_changed, :image_changed, :url_changed, :site_name_changed, :keywords_changed, :type_changed

    %w(title description image url site_name keywords type).each do |label|
      class_eval <<-CLASS
        def #{ label }
          @#{ label } || default_#{ label }
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

    def description
      @description.gsub(/<[^>]+?>/, " ")
    end

    def reset_changed_status
      %w(title description image url site_name keywords type).each do |label|
        self.send("#{ label }_changed=", false)
      end
    end
  end
end