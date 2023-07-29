namespace :ignored_columns do
  def model
    ENV["MODEL"].constantize if ENV["MODEL"]
  end

  desc "Output ignored columns for MODEL that have been dropped; if MODEL not given output for all"
  task :dropped => :environment do
    IgnoredColumnsTasks.dropped(model)
  end

  desc "Generate a migration to drop ignored columns for MODEL; if MODEL not given create migrations for all"
  task :migration => :environment do
    IgnoredColumnsTasks.migration(model)
  end
end
