module MetaTags
  module Tags
    class Image < Base
      def value
        instance_image
      end

      private

      def instance_image
        if member_action?
          MetaTags.image_methods.each do |method|
            if instance.respond_to?(method) && instance.send(method)
              return instance.send(method).url
            end
          end

          nil
        end
      end
    end
  end
end
