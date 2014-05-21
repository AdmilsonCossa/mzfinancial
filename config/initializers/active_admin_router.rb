module ActiveAdmin
  class Router
    def nested_routes_for(router, parent, child)
      namespace = @application.namespace(@application.default_namespace)
      resource = namespace.resource_for(child.to_s.classify.constantize)

      router.instance_exec resource, self do |config, aa_router|
        namespace config.namespace.name do
          resources parent, only: [] do
            instance_exec &aa_router.resource_routes(config)
          end
        end
      end
    end
  end
end
