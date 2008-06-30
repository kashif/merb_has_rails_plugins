# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # :rails_env    - Rails environment - probably want to leave this as the default
  # :rails_root   - Path to your rails root
  # :plugins_root - Path to your rails plugins directory
  # :only         - Optional array of the subset of plugins you want to load i.e. ['acts_as_hasselhoff', 'foo_fu']
  defaults = {
   :rails_env    => Merb.env,
   :rails_root   => Merb.root / '..',
   :plugins_root => Merb.root / '..' / 'vendor' / 'plugins',
   :only => nil, 
  }
  
  config = Merb::Plugins.config[:merb_has_rails_plugins]
  config = defaults.merge config
   
  RAILS_ROOT = config[:rails_root] unless defined?(RAILS_ROOT)
  RAILS_ENV  = config[:rails_env] unless defined?(RAILS_ENV)
  
  Merb.logger.info "loading rails plugins from '#{config[:plugins_root]}' ..."
  Dir[config[:plugins_root] / '*'].each do |dir|
    plugin = dir.split(File::SEPARATOR).last
    if config[:only].blank? || config[:only].include?(plugin)
      Merb.logger.info "loading rails plugin '#{plugin}' ..."
      plugin_init, plugin_lib = dir / 'init.rb', dir / 'lib'
   	
     	if File.directory?(plugin_lib) 
     	  if defined?(ActiveSupport) 
     	    Dependencies.load_paths << plugin_lib 
     	    Dependencies.load_once_paths << plugin_lib 
        end
        $LOAD_PATH << plugin_lib
      end
      require plugin_init if File.exist?(plugin_init)
    end
  end
end