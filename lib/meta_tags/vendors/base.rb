module MetaTags
  module Vendors
    class Base
      include ActionView::Helpers::TagHelper

      attr_reader :template

      def initialize(template)
        @template = template
      end

      def render(key, value)
        tag(:meta, key_name => attribute_name_for(key), value: value)
      end

      protected

      def attribute_name_for(key)
        [namespace, key].join(':')
      end
    end
  end
end
