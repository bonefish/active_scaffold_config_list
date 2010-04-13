module ActiveScaffold
  module Helpers
    module ViewHelpers
      # Add the cf_as plugin includes
      def active_scaffold_includes_with_cf_as(frontend = :default)
        css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('cf_as-stylesheet.css', frontend))
        ie_css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path("cf_as-stylesheet-ie.css", frontend))
        active_scaffold_includes_without_cf_as + "\n" + css + "\n<!--[if IE]>" + ie_css + "<![endif]-->\n"
      end
      alias_method_chain :active_scaffold_includes, :cf_as
#
#      # This is a hack around my need to put an image tag inside the action link.
#      # I store the string to eval in a parameter and remove it out in this method
#      # before invoking the normal render_action_link
#      def render_action_link_with_aal(link, url_options)
#        link_copy = link.clone
#        if !link_copy.parameters.nil? && link_copy.parameters[:eval_label]
#          link_copy.parameters = link.parameters.clone
#          link_copy.label = eval(link_copy.parameters.delete(:eval_label))
#        end
#        render_action_link_without_aal(link_copy, url_options)
#      end
#      alias_method_chain :render_action_link, :aal
    end
  end
end
