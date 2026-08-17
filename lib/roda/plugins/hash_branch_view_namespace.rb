# frozen-string-literal: true

class Roda
  module RodaPlugins
    module HashBranchViewNamespace
      def self.load_dependencies(app)
        app.plugin :hash_branches
        app.plugin :view_options
      end

      def self.configure(app)
        app.opts[:hash_branch_view_subdir_methods] ||= {}
      end

      module ClassMethods
        def freeze
          opts[:hash_branch_view_subdir_methods].freeze.each_value(&:freeze)
          super
        end

        def inherited(subclass)
          super

          h = subclass.opts[:hash_branch_view_subdir_methods]
          opts[:hash_branch_view_subdir_methods].each do |namespace, routes|
            h[namespace] = routes.dup
          end
        end

        def hash_branch(namespace='', segment, &block)
          meths = opts[:hash_branch_view_subdir_methods][namespace] ||= {}

          if block
            meth = meths[segment] = define_roda_method(meths[segment] || "_hash_branch_view_subdir_#{namespace}_#{segment}", 1, &convert_route_block(block))
            super do |*_|
              append_view_subdir("#{namespace}/#{segment}")
              send(meth, @_request)
            end
          else
            if meth = meths.delete(segment)
              remove_method(meth)
            end
            super
          end
        end
      end
    end

    register_plugin(:hash_branch_view_namespace, HashBranchViewNamespace)
  end
end
