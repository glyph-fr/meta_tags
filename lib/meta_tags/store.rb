module MetaTags
  class Store
    attr_reader :controller, :defaults

    TAGS = :title, :description, :image, :url, :site_name, :keywords, :type,
           :site, :card

    attr_writer :charset, *TAGS

    def initialize(controller)
      @controller = controller

      @defaults = if MetaTags.defaults
        controller.instance_exec(&MetaTags.defaults)
      else
        {}
      end
    end

    TAGS.each do |tag_name|
      define_method(tag_name) do
        if (value = instance_variable_get(:"@#{ tag_name }"))
          value
        else
          value = if (processor = MetaTags::Tags[tag_name])
            processor.new(controller).value
          else
            defaults[tag_name]
          end

          instance_variable_set(:"@#{ tag_name }", value) if value
        end
      end
    end

    def charset
      @charset ||= 'utf-8'
    end
  end
end
