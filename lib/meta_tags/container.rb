module MetaTags
  class Container
    attr_accessor :default_title, :default_description, :default_keywords,
      :default_image, :title_changed, :description_changed, :keywords_changed, :image_changed

    %w(title description keywords image).each do |label|
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
      @title = "#{ value } - #{ default_title }"
    end
    
    def reset_changed_status
      %w(title description keywords image).each do |label|
        self.send("#{ label }_changed=", false)
      end
    end
  end
end