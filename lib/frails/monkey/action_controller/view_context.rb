# frozen_string_literal: true

module Frails
  module Monkey
    module ActionController
      module ViewContext
        def self.prepended(mod)
          mod.class_eval do
            helper_method :layout_name, :rendered_view_path
            attr_accessor :active_template
          end
        end

        def rendered_view_path
          @rendered_view_path ||= active_template&.virtual_path
        end

        def layout_name
          if Rails::VERSION::MAJOR >= 6
            send(:_layout, lookup_context, ['null']) || 'application'
          else
            send(:_layout, ['null']) || 'application'
          end
        end
      end
    end
  end
end
