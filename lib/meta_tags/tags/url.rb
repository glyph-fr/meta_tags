module MetaTags
  module Tags
    class Url < Base
      def process!
        controller.request.original_url
      end
    end
  end
end