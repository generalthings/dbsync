require "dbsync/version"
require "dbsync/railtie"
require "dbsync/config"
require "dbsync/syncer"

##
# Dbsync
#
module Dbsync
  class << self
    def config
      @config ||= Dbsync::Config.new(Rails.application.config.dbsync)
    end

    def log(msg)
      logger.puts "*** #{msg}"
    end
    
    #------------------
    
    private
    
    def logger
      $stdout
    end
  end
end
