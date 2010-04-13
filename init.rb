# Make sure that ActiveScaffold has already been included
ActiveScaffold rescue throw "should have included ActiveScaffold plug in first.  Please make sure that this overwrite plugging comes alphabetically after the ActiveScaffold plug in"

# set our directory
$:.unshift(File.dirname(__FILE__))

# Load our overrides
Kernel::load 'lib/config/core.rb'
Kernel::load 'lib/config/config_list.rb'
Kernel::load 'lib/actions/config_list.rb'
Kernel::load 'lib/helpers/view_helpers.rb'

##
## Run the install script, too, just to make sure
##
require File.dirname(__FILE__) + '/install'

ActionView::Base.send(:include, ActiveScaffold::Helpers::ViewHelpers)
