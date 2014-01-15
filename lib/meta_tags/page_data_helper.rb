require "meta_tags/tags/base"
require "meta_tags/tags/title"
require "meta_tags/tags/description"
require "meta_tags/tags/keywords"
require "meta_tags/tags/image"
require "meta_tags/tags/url"

module MetaTags
  module PageDataHelper
    def process_meta_tag tag
      if (processor = processors[tag])
        processor.new(self).process!
      end
    end

    def processors
      @processors ||= %w(title description image keywords url).reduce({}) do |hash, tag|
        hash[tag] = MetaTags::Tags.const_get(tag.camelize)
        hash
      end
    end
  end
end