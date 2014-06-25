module MetaTags
  module Controller
    extend ActiveSupport::Concern
    include PageDataHelper

    module ClassMethods
      attr_accessor :meta_tags, :model_name, :modifier_block

      def meta_tags_defaults options
        @meta_tags = Container.new(options)
      end

      def meta_tags_from model_name = nil, &block
        @model_name = model_name && model_name.to_s
        @modifier_block = block_given? ? block : nil
      end
    end

    included do
      helper_method :meta_tags, :meta_tags_container, :set_meta_tag,
        :meta_tags_data

      after_filter do
        meta_tags_container.reset_changed_status if meta_tags_container
      end
    end

    attr_reader :instance

    def meta_tags_container
      @_meta_tags_container ||= ::ApplicationController.meta_tags.dup
    end

    def meta_tags_data
      process_meta_tags
      meta_tags_container
    end

    def meta_tags_for identifier
      if identifier.kind_of?(ActiveRecord::Base)
        @instance = identifier
      elsif (list = MetaTags::List.where(identifier: identifier.to_s).first)
        %w(title description keywords).each do |key|
          if (value = list.send(:"meta_#{ key }").presence)
            meta_tags_container.send(:"#{ key }=", value)
          end
        end
      end
    end

    def meta_tags *providers
      options = providers.pop if providers.last.is_a? Hash
      charset = options[:encoding] rescue 'utf-8'

      data = meta_tags_data

      # Required meta tags
      markup = <<-HTML
        <meta charset="#{ charset }">
        <title>#{ data.title }</title>
      HTML

      if data.keywords.presence
        markup << "<meta name=\"keywords\" content=\"#{ data.keywords }\">"
      end

      # Default meta tags
      markup << markup_from_provider(:default)

      # Meta tags by provider
      providers.each do |provider|
        str = markup_from_provider provider

        # Prevents same meta tags added twice
        markup << str if !markup.include?(str)
      end

      markup.html_safe
    end

    def markup_from_provider provider=:default
      tags = case provider.to_sym

      when :open_graph
        {
          title: "property=\"og:title\"",
          description: "property=\"og:description\"",
          image: "property=\"og:image\"",
          type: "property=\"og:type\"",
          url: "property=\"og:url\"",
          site_name: "property=\"og:site_name\""
        }
      when :twitter
        {
          title: "name=\"twitter:title\"",
          description: "name=\"twitter:description\"",
          image: "name=\"twitter:image\"",
          url: "name=\"twitter:url\"",
          site: "name=\"twitter:site\"",
          card: "name=\"twitter:card\""
        }
      else
        {
          description: "name=\"description\"",
          image: "name=\"og:image\""
        }
      end

      tags.each_with_object("") do |(key, property_string), buffer|
        if (content = meta_tags_container.send(key)).presence
          buffer << "<meta #{ property_string } content=\"#{ content }\">\n"
        end
      end
    end

    def process_meta_tags
      Container::TAGS_LIST.each do |label|
        next if meta_tags_container.send(:"#{ label }_changed?")

        data = process_meta_tag(label)

        if data
          set_meta_tag(label, data)
        else
          set_meta_tag(label, meta_tags_container.send(:"default_#{label}"))
        end
      end
    end

    def set_meta_tag key, value, options = {}
      if value.presence && !options[:force]
        meta_tags_container.send("#{ key }=", value)
      end
    end
  end
end
