module MetaTags
  module Tags
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Title
    autoload :Description
    autoload :Keywords
    autoload :Image
    autoload :Url

    def self.[](tag_name)
      processors[tag_name]
    end

    private

    def self.processors
      @processors ||= [:title, :description, :keywords, :image, :url].reduce({}) do |hash, tag|
        hash[tag] = MetaTags::Tags.const_get(tag.to_s.camelize)
        hash
      end
    end
  end
end
