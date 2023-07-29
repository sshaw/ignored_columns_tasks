module IgnoredColumnTasks
  class Railtie < Rails::Railtie
    rake_tasks do
      load "ignored_columns_tasks/tasks/ignored_columns.rake"
    end
  end
end
