# Make sure that ActiveScaffold has already been included
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

# Load our overrides
require "#{File.dirname(__FILE__)}/lib/active_scaffold/config/core.rb"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/config/config_list.rb"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/actions/config_list.rb"
require "#{File.dirname(__FILE__)}/lib/active_scaffold/helpers/view_helpers_override.rb"

##
## Run the install script, too, just to make sure
## But at least rescue the action in production
##
begin
  require File.dirname(__FILE__) + '/install'
rescue
  raise $! unless RAILS_ENV == 'production'
end

# Add the actions as default actions.
ActiveScaffold.set_defaults do |config|
  [ :config_list
    #add here registration for actions
    
    ].each do |action|
    config.actions.add action
  end
end
