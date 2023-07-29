require "ignored_columns_tasks/version"
require "rails/generators"

module IgnoredColumnsTasks
  class Column
    attr_reader :klass, :name, :data

    def initialize(klass, name, data = nil)
      @klass = klass
      @name = name
      # Aren't using this now outside of exists
      @data = data
    end

    def exists?
      !@data.nil?
    end

    def to_s
      name
    end
  end

  class << self
    ##
    #
    # Output ignored columns that have been dropped for +model+.
    # If +model+ is not given output for all classes
    #
    # +model+ must a an ActiveRecord::Base subclass
    #
    def dropped(options = nil)
      Rails.application.eager_load!

      ignored = find_columns(options || {})
      if ignored.none?
        puts "No ignored columns exist"
        return
      end

      dropped = ignored.reject(&:exists?)
      if dropped.none?
        puts "No ignored columns have been dropped"
        return
      end

      dropped.group_by(&:klass).sort_by { |klass, _| klass.name }.each do |klass, columns|
        puts "%s: %s" % [klass.name, columns.sort_by(&:name).to_sentence]
      end
    end

    ##
    #
    # Generate a migration to drop ignored columns for +model+.
    # If +model+ is not given create migrations for all classes
    # with ignored columns. 1 migration per class.
    #
    # +model+ must a an ActiveRecord::Base subclass
    #
    def migration(options = nil)
      Rails.application.eager_load!

      ignored_columns = find_columns(options || {})
      if ignored_columns.none?
        puts "No ignored columns exist"
        return
      end

      to_drop = ignored_columns.select(&:exists?)
      if to_drop.none?
        puts "No ignored columns to drop"
        return
      end

      to_drop.group_by(&:klass).each do |klass, columns|
        migration = "remove_ignored_columns_from_#{klass.table_name}"

        # Assume Rails does the shell quoting on Column#name?
        Rails::Generators.invoke("active_record:migration", [migration, columns.map(&:name)])
      end
    end

    private

    def all_classes
      (ApplicationRecord.subclasses + ActiveRecord::Base.subclasses).reject do |klass|
        klass.abstract_class? || klass.ignored_columns.none?
      end
    end

    def class_with_all_columns(klass)
      ignored = klass.ignored_columns

      klass.ignored_columns = []
      klass.reset_column_information
      yield klass, ignored.dup
    ensure
      # I mean do we really need to do this?
      klass.ignored_columns = ignored
    end

    def find_columns(options)
      if options[:model]
        ignored_columns(options[:model], options[:skip_columns])
      else
        all_classes.flat_map { |klass| ignored_columns(klass, options[:skip_columns]) }
      end
    end

    def ignored_columns(klass, skip = nil)
      skip ||= []
      class_with_all_columns klass do |class_with_all, ignored|
        ignored -= skip if skip.any?
        ignored.map { |column| Column.new(class_with_all, column, class_with_all.columns_hash[column]) }
      end
    end
  end
end

require "ignored_columns_tasks/railtie" if defined?(Rails::Railtie)
