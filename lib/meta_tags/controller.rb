module MetaTags
  module Controller
    extend ActiveSupport::Concern
    include PageDataHelper

    module ClassMethods
      attr_accessor :meta_tags, :model_name

      def meta_tags_defaults options
        @meta_tags = Container.new(options)
      end

      def meta_tags_from model_name
        @model_name = model_name.to_s
      end
    end

    included do
      helper_method :meta_tags, :meta_tags_container, :set_meta_tag,
        :meta_tags_data

      after_filter do
        meta_tags_container.reset_changed_status if meta_tags_container
      end
    end

    def meta_tags_container
      @_meta_tags_container ||= self.class.ancestors.find { |klass|
        klass.to_s == "ApplicationController"
      }.meta_tags
    end

    def meta_tags_data
      process_meta_tags
      meta_tags_container
    end

    def meta_tags *providers
      options = providers.pop if providers.last.is_a? Hash
      charset = options[:encoding] rescue 'utf-8'

      data = meta_tags_data
      # Compulsory meta tags
      markup = <<-HTML
        <title>#{ data.title }</title>
        <meta charset="#{ charset }">
        <meta name="publisher" content="GLYPH">
        <meta name="keywords" content="#{ data.keywords }">
        <meta property="og:type" content="#{ data.type }">
        <meta property="og:url" content="#{ data.url }">
        <meta property="og:site_name" content="#{ data.site_name }">
      HTML

      # Default meta tags
      markup += markup_from_provider

      # Meta tags by provider
      providers.each do |provider|
        str = markup_from_provider provider

        # Prevents same meta tags added twice
        markup += str if !markup.include?(str)
      end

      markup.html_safe
    end

    def markup_from_provider provider=:default
      case provider.to_sym
        when :open_graph
          title = "property=\"og:title\""
          description = "property=\"og:description\""
          image = "property=\"og:image\""
        when :twitter
          title = "name=\"twitter:title\""
          description = "name=\"twitter:description\""
          image = "name=\"twitter:image\""
        else
          title = "name=\"title\""
          description = "name=\"description\""
          image = "property=\"og:image\""
      end
      result = ''

      result += "<meta #{ title } content=\"#{ meta_tags_container.title }\">" if title
      result += "<meta #{ description } content=\"#{ meta_tags_container.description }\">" if description
      result += "<meta #{ image } content=\"#{ meta_tags_container.image }\">" if image

      result
    end

    def process_meta_tags
      %w(title description image url site_name keywords type).each do |label|
        next if meta_tags_container.send("#{ label }_changed?")
        data = send("process_#{ label }")
        if data
          set_meta_tag label, data
        else
          set_meta_tag label, meta_tags_container.send("default_#{label}")
        end
      end
    end

    def set_meta_tag key, value
      meta_tags_container.send("#{ key }=", value)
    end
  end
end
