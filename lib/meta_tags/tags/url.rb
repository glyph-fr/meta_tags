module MetaTags
  module Tags
    class Url < Base
      def value
        controller.request.original_url
      end
    end
  end
end
