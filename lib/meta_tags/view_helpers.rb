module MetaTags
  module ViewHelpers
    def meta_tags(options = {})
      MetaTags::Renderer.new(self, options).render
    end
  end
end
