module MetaTags
  module Tags
    class Base
      attr_accessor :controller

      def initialize controller
        @controller = controller
      end

      protected

      def member_action?
        controller.params.key?(:id)
      end

      def action_i18n label
        options = modifier_options.merge(default: "")
        I18n.t(action_key(label), options).presence
      end

      def action_key label
        key = %w(meta_tags controller)
        key << controller.params[:controller]
        key << controller.params[:action]
        key << label
        key.join(".")
      end

      def instance
        return controller.instance if controller.instance

        @instance ||= if model_name
          controller.instance_variable_get(:"@#{ model_name }")
        end
      end

      def model_name
        controller.class.model_name.presence
      end

      def modifier_options
        @modifier_options ||= if controller.class.modifier_block
          instance_eval(&controller.class.modifier_block)
        else
          {}
        end
      end
    end
  end
end
