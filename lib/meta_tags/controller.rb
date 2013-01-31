module MetaTags
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :meta_tags

      def meta_tags_defaults options
        @meta_tags = Container.new(options)
        puts self.inspect
      end
    end

    included do
      helper_method :meta_tags, :meta_tags_container, :set_meta_tag
    end

    def meta_tags_container
      @_meta_tags_container ||= self.class.ancestors.find { |klass|
        klass.to_s == "ApplicationController"
      }.meta_tags
    end

    def meta_tags
      markup = <<-HTML
        <title>#{ meta_tags_container.title }</title>
        <meta name="description" content="#{ meta_tags_container.description }">
        <meta name="keywords" content="#{ meta_tags_container.keywords }">
        <meta name="og:title" content="#{ meta_tags_container.title }">
        <meta name="og:description" content="#{ meta_tags_container.description }">
        <meta name="og:image" content="#{ meta_tags_container.image }">
      HTML

      markup.html_safe
    end

    def set_meta_tag key, value
      meta_tags_container.send("#{ key }=", value)
    end
  end
end
