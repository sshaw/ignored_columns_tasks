# Ignored Columns Tasks

Rails tasks for managing
[Active Record ignored columns](https://api.rubyonrails.org/v7.0.6/classes/ActiveRecord/ModelSchema/ClassMethods.html#method-i-ignored_columns-3D).

## Installation

Add this line to your application's `Gemfile` in the `:development` group:

```ruby
group :development do
  gem "ignored_columns_tasks"
end
```

## Usage

All functionality is provided as Rake tasks.

### Generating a Migration to Drop Ignored Columns

This will generate (but not run!) migrations to drop columns currently being ignored. One migration is generated per model:

```
./bin/rails ignored_columns:migration
```

If you have ignored columns that must not be dropped add them to the `SKIP_COLUMNS` environment variable:

```
./bin/rails ignored_columns:migration SKIP_COLUMNS="some_column,another_column"
```

You can set this once for your project instead of specifying it every time.
In this case it is recommended to use the `IGNORED_COLUMNS_TASKS_SKIP_COLUMNS` environment variable:

```sh
export IGNORED_COLUMNS_TASKS_SKIP_COLUMNS="some_column,another_column"
```

This task can also be limited to a single model by setting the `MODEL` environment variable:

```
./bin/rails ignored_columns:migration MODEL=User
```

### Ignored Columns That Have Been Dropped From Your Database

This will print ignored columns that no longer exist the database:

```
./bin/rails ignored_columns:dropped
```

This can be limited to a single model via the `MODEL` environment variable:

```
./bin/rails ignored_columns:dropped MODEL=User
```

## Author

Skye Shaw (skye.shaw +AT+ gmail)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
