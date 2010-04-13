module ActiveScaffold::Config
  class ConfigList < Form
    self.crud_type = :create
    def initialize(*args)
      super
      @available_columns = Array.new
      @default_columns = Array.new
      @enabled = true
    end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    def self.link
      @@link
    end
    def self.link=(val)
      @@link = val
    end
    @@link = ActiveScaffold::DataStructures::ActionLink.new('prepare_config_list', :label => 'List columns..', :type => :table, :security_method => :create_authorized?)

    # instance-level configuration
    # ----------------------------
    # the label= method already exists in the Form base class
    def label
      @label ? as_(@label) : as_('Config list %s columns', @core.label.singularize)
    end

    @available_columns = Array.new
    attr_accessor :available_columns
    
    @default_columns = Array.new
    attr_accessor :default_columns
    
    @enabled = true
    attr_accessor :enabled
  end
end
