module MetaTags
  module Vendors
    class Twitter < MetaTags::Vendors::Base
      def tags
        [:title, :description, :image, :url, :site, :card]
      end

      protected

      def key_name
        'name'
      end

      def namespace
        'twitter'
      end
    end
  end
end
