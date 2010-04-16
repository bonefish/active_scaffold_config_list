module ActiveScaffold::Actions
  module ConfigList
    
    def self.included(base)
      base.before_filter :exclude_columns
      base.before_filter :exclude_config_list, :only => [:index, :list, :table]

      as_config_list_plugin_path = File.join(Rails.root, 'vendor', 'plugins', ActiveScaffold::Config::ConfigList.plugin_directory, 'frontends', 'default' , 'views')
      
      base.add_active_scaffold_path as_config_list_plugin_path
    end

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
      
      if c.size > 0
        session[self.class.to_s + '_col'] = c       
      end
     
    end
   

  end
end
