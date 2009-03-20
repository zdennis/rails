require "action_controller/abstract/logger"

module AbstractController
  module Renderer
    
    def self.included(klass)
      klass.class_eval do        
        extend ClassMethods
        
        attr_internal :formats
        
        extlib_inheritable_accessor :_view_paths
        
        self._view_paths ||= ActionView::PathSet.new
        include AbstractController::Logger
      end
    end
    
    def _action_view
      @_action_view ||= ActionView::Base.new(self.class.view_paths, {}, self)      
    end
        
    def render(name = action_name, options = {})
      self.response_body = render_to_string(name, options)
    end
    
    # Raw rendering of a template.
    # ====
    # @option _prefix<String> The template's path prefix
    # @option _layout<String> The relative path to the layout template to use
    # 
    # :api: plugin
    def render_to_string(name = action_name, options = {})
      template = options[:_template] || view_paths.find_by_parts(name.to_s, formats, options[:_prefix])
      _render_template(template, options)
    end

    def _render_template(template, options)
      _action_view._render_template_with_layout(template)
    end
    
    def view_paths() _view_paths end

    module ClassMethods
      
      def append_view_path(path)
        self.view_paths << path
      end
      
      def view_paths
        self._view_paths
      end
      
      def view_paths=(paths)
        self._view_paths = paths.is_a?(ActionView::PathSet) ?
                            paths : ActionView::Base.process_view_paths(paths)
      end
    end
  end
end