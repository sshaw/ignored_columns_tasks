require_relative 'lib/ignored_columns_tasks/version'

Gem::Specification.new do |spec|
  spec.name          = "ignored_columns_tasks"
  spec.version       = IgnoredColumnsTasks::VERSION
  spec.authors       = ["Skye Shaw"]
  spec.email         = ["skye.shaw@gmail.com"]

  spec.summary       = %q{Rails tasks for managing Active Record ignored columns}
  spec.description   = %q{Rails tasks to create migrations to remove ignored columns and output dropped columns that are still being ignored}
  spec.homepage      = "https://github.com/sshaw/ignored_columns_tasks"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sshaw/ignored_columns_tasks"
  spec.metadata["changelog_uri"] = "https://github.com/sshaw/ignored_columns_tasks/blob/master/Changes"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
