#module ActiveScaffold::Config
#  class Core
#    # configures where the active_scaffold_config_list plugin itself is located. there is no instance version of this.
#    cattr_accessor :cl_as_plugin_directory
#    @@cl_as_plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]
#
#    # the active_scaffold_aal template path
#    def template_search_path_with_cl_as
#      frontends_path = "../../vendor/plugins/#{ActiveScaffold::Config::Core.cl_as_plugin_directory}/frontends"
#      search_path = template_search_path_without_cl_as
#      search_path << "#{frontends_path}/#{frontend}/views" if frontend.to_sym != :default
#      search_path << "#{frontends_path}/default/views"
#      return search_path
#    end
#
#    alias_method_chain :template_search_path, :cl_as
#  end
#end

# Add the actions as default actions.
ActiveScaffold.set_defaults do |config|
  [ :config_list
    #add here registration for actions
    
    ].each do |action|
    config.actions.add action
  end
end
