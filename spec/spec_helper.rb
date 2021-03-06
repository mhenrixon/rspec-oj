# frozen_string_literal: true

require 'simplecov'
require 'rspec-oj'
require 'pry'

def files_path
  File.expand_path('support/files', __dir__)
end

RSpec.configure do |config|
  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.before do
    RSpec::Oj.reset
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/.rspec-status'
  config.disable_monkey_patching!
  config.warnings = true
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
