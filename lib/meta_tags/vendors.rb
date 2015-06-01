module MetaTags
  module Vendors
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :OpenGraph
    autoload :Twitter

    def self.for(vendor_name)
      const_get(vendor_name.to_s.camelize)
    end
  end
end
