module MetaTags
  module Vendors
    class OpenGraph < MetaTags::Vendors::Base
      def tags
        [:title, :description, :image, :type, :url, :site_name]
      end

      protected

      def key_name
        'property'
      end

      def namespace
        'og'
      end
    end
  end
end
