require 'rubygems'
# keep for compatibility for now
require 'puppetlabs_spec_helper/rake_tasks'
task :tests do
  # run syntax checks on manifests, templates and hiera data
  # also runs :metadata_lint
  Rake::Task[:validate].invoke

  # runs puppet-lint
  Rake::Task[:lint].invoke
end
