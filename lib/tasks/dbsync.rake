desc "Alias for dbsync:pull"
task :dbsync do
  Rake::Task["dbsync:pull"].invoke
end

namespace :dbsync do
  task :setup => :environment do
    Dbsync.info "Environment: #{Rails.env}"
    
    if Rails.env == 'production'
      raise "These tasks are destructive and shouldn't be used in the production environment."
    end

    #-----------------
    
    if Dbsync.config.filename.blank?
      raise "No dump filename specified."
    elsif Dbsync.config.remote.blank?
      raise "No remote dump file specified."
    end
    
    #-----------------
    
    Dbsync.config.verbose = %w{1 true}.include? ENV['VERBOSE']
    Dbsync.config.database = ActiveRecord::Base.configurations[Rails.env]
  end
  
  #-----------------------
  
  desc "Show the dbsync configuration"
  task :config => :setup do
    Dbsync.info "Config:"
    Dbsync.info Dbsync.config.to_yaml
  end
    
  #-----------------------
    
  desc "Update the local dump file, and merge it into the local database"
  task :pull => [:fetch, :merge]
  
  desc "Copy the remote dump file, reset the local database, and load in the dump file"
  task :clone => [:clone_dump, :reset]
  
  #-----------------------
  
  desc "Update the local dump file from the remote source"
  task :fetch => :setup do
    Dbsync.info "Fetching #{Dbsync.config.remote} using rsync"
    output = %x{ rsync -v #{Dbsync.config.remote} #{Dbsync.config.local} }
    
    Dbsync.debug output
    Dbsync.info "Finished."
  end

  #-----------------------

  desc "Copy the remote dump file to a local destination"
  task :clone_dump => :setup do
    Dbsync.info "Fetching #{Dbsync.config.remote} using scp"
    output = %x{ scp #{Dbsync.config.remote} #{Dbsync.config.local_dir}/ }
    
    Dbsync.debug output
    Dbsync.info "Finished."
  end

  #-----------------------
  
  desc "Merge the local dump file into the local database"
  task :merge => :setup do
    Dbsync.info "Dumping data from #{Dbsync.config.local} into #{Dbsync.config.database['database']}"

    command =  "mysql "
    command += "-u #{Dbsync.config.database['username']} " if Dbsync.config.database['username'].present?
    command += "-p#{Dbsync.config.database['password']} "  if Dbsync.config.database['password'].present?
    command += "-h #{Dbsync.config.database['host']} "     if Dbsync.config.database['host'].present?
    command += "#{Dbsync.config.database['database']} < #{Dbsync.config.local}"
    
    output = %x{#{command}}
    
    Dbsync.debug outout
    Dbsync.info "Finished."
  end

  #-----------------------
  
  desc "Drop & Create the database, then load the dump file."
  task :reset => :setup do
    Dbsync.debug "Resetting database..."
    
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["dbsync:merge"].invoke
  end
end
