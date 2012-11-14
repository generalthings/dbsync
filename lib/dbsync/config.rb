##
# Dbsync::Config
#
module Dbsync
  class Config
    attr_accessor :filename, :local_dir, :remote_host, :remote_dir, :database, :verbose
    
    # Pass in a hash of options
    def initialize(config={})
      @filename    = config[:filename]
      @local_dir   = config[:local_dir]
      @remote_host = config[:remote_host]
      @remote_dir  = config[:remote_dir]
      @database    = config[:database]
      @verbose     = config[:verbose]
    end
    
    def remote
      "#{CONFIG['remote_host']}:" + File.join(CONFIG['remote_dir'], CONFIG['filename'])
    end
    
    def local
      File.join CONFIG['local_dir'], CONFIG['filename']
    end
  end
end
