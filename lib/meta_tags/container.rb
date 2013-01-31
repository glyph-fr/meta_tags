module MetaTags
  class Container
    attr_accessor :default_title, :default_description, :default_keywords,
      :default_image, :title, :description, :keywords, :image

    %w(title description keywords image).each do |label|
      class_eval <<-CLASS
        def #{ label }
          @#{ label } || default_#{ label }
        end
      CLASS
    end

    def initialize options
      options.each do |label, value|
        self.send("default_#{ label }=", value)
      end
    end

    def title=(value)
      @title = "#{ value } - #{ default_title }"
    end
  end
end