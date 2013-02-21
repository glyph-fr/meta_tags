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
      helper_method :meta_tags, :meta_tags_container, :set_meta_tag
      after_filter do 
        meta_tags_container.reset_changed_status
      end
    end

    def meta_tags_container
      @_meta_tags_container ||= self.class.ancestors.find { |klass|
        klass.to_s == "ApplicationController"
      }.meta_tags
    end

    def meta_tags
      process_meta_tags

      description = meta_tags_container.description.gsub(/<[^>]+?>/, " ")
      
      markup = <<-HTML
        <title>#{ meta_tags_container.title }</title>
        <meta name="description" content="#{ description }">
        <meta name="keywords" content="#{ meta_tags_container.keywords }">
        <meta name="og:title" content="#{ meta_tags_container.title }">
        <meta name="og:description" content="#{ description }">
        <meta name="og:image" content="#{ meta_tags_container.image }">
      HTML

      markup.html_safe
    end

    def process_meta_tags
      %w(title description image keywords).each do |label|
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
