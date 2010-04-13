module ActiveScaffold::Actions
  module ConfigList
    
    def self.included(base)
      #base.verify :method => :post,
      #            :only => :config_list,
      #            :redirect_to => { :action => :index }
                
      base.before_filter :exclude_columns
      base.before_filter :exclude_config_list, :only => [:index, :list, :table]
#start
      as_config_list_plugin_path = File.join(RAILS_ROOT, 'vendor', 'plugins', as_config_list_plugin_name, 'frontends', 'default', 'views')
      
      if base.respond_to?(:generic_view_paths) && ! base.generic_view_paths.empty?
        base.generic_view_paths.insert(0, as_config_list_plugin_path)
      else  
        config.inherited_view_paths << as_config_list_plugin_path
      end
    end
    def self.as_config_list_plugin_name
      # extract the name of the plugin as installed
      /.+vendor\/plugins\/(.+)\/lib/.match(__FILE__)
      plugin_name = $1
    end
#--
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
#end

    def prepare_config_list
      @available_columns = active_scaffold_config.config_list.available_columns.map do |c| 
        label = ''
        active_scaffold_config.columns.map{|l| label = l.label if l.name.to_s == c } 
        { :param_name => 'col_' + c, :name => c, :label => label }
      end
      
      @columns = session_columns
      
      respond_to do |type|
        type.html do
          if successful?
            render(:action => 'config_list_form', :layout => true)
          else
            return_to_main
          end
        end
        type.js do
          render(:partial => 'config_list_form', :layout => false)
        end
      end
    end
    
    def exclude_columns
      return if !config_list_enabled?
            
      if active_scaffold_config.config_list.available_columns.size == 0
        active_scaffold_config.list.columns.each do |c|
          active_scaffold_config.config_list.available_columns << c.name.to_s
        end
      end
      
      if active_scaffold_config.config_list.default_columns.size == 0
        active_scaffold_config.list.columns.each do |c|
          active_scaffold_config.config_list.default_columns << c.name.to_s
        end
      end
      
      do_config_list

      reset_session_columns if params[:commit] == "reset_to_default"
      if params[:commit] == "show_all_columns"
        show = show_all_columns
      else
        show = session_columns
      end

      active_scaffold_config.config_list.available_columns.each do |c|
         if !show.include?( c.to_s )
            if !active_scaffold_config.list.columns.find_by_name( c.to_sym ).nil?
             active_scaffold_config.list.columns.exclude c.to_sym
            end
         else
           if active_scaffold_config.list.columns.find_by_name( c.to_sym ).nil?
             active_scaffold_config.list.columns << c.to_sym
            end
         end
      end
    end
    
    def exclude_config_list
      if !config_list_enabled?
        active_scaffold_config.action_links.delete("prepare_config_list")
        active_scaffold_config.actions.exclude(:config_list)
      end
    end

    def config_list_enabled? 
      active_scaffold_config.config_list.enabled
    end
    
    def session_columns
      show = session[ self.class.to_s + '_col']

      if show.nil? || show.size == 0
        show = active_scaffold_config.config_list.default_columns.map{|c| c.to_s }
        session[self.class.to_s + '_col'] = show
      end
      
      show
    end

    def show_all_columns
      show = active_scaffold_config.config_list.available_columns.map{|c| c.to_s }
      session[self.class.to_s + '_col'] = show
      show
    end
    
    def reset_session_columns
      session[self.class.to_s + '_col'] = nil
    end

    protected

    def do_config_list
      
      columns = active_scaffold_config.config_list.available_columns.map{|c|c}
      c = Array.new 
    
      params.each do |name,value|
         n = name[4..name.length]
         if name[0..3] == 'col_' && ( columns.include? n )
             c << n
         end
      end
      
      #hack for exports
      ProgramAction.exportable_columns.each do |col|
        if c.include? col.to_s
          c << "exportable_column_values" unless c.include? "exportable_column_values"
        end
      end
      
      if c.size > 0
        session[self.class.to_s + '_col'] = c       
      end
     
    end

  end
end
