namespace :ignored_columns do
  def options
    optz = {}
    optz[:model] = ENV["MODEL"].constantize if ENV["MODEL"]
    optz[:skip_columns] = skip_columns
    optz
  end

  def skip_columns
    skip = nil

    # IGNORED_COLUMNS_TASKS_SKIP_COLUMNS is our global, namespaced version
    # SKIP_COLUMNS is shorter, command-line argument
    %w[IGNORED_COLUMNS_TASKS_SKIP_COLUMNS SKIP_COLUMNS].each do |name|
      if ENV[name]
        skip ||= []
        skip.concat(ENV[name].split(/\s*,\s/))
      end
    end

    skip
  end

  desc "Output ignored columns for MODEL that have been dropped, ignoring SKIP_COLUMNS; if MODEL not given output for all"
  task :dropped => :environment do
    IgnoredColumnsTasks.dropped(options)
  end

  desc "Generate a migration to drop ignored columns for MODEL, ignoring SKIP_COLUMNS; if MODEL not given create migrations for all"
  task :migration => :environment do
    IgnoredColumnsTasks.migration(options)
  end
end
