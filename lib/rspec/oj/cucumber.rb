# frozen_string_literal: true

require 'rspec-oj'

World(RSpec::Oj::Helpers, RSpec::Oj::Matchers)

After do
  RSpec::Oj.forget
end

When(/^(?:I )?keep the (?:JSON|json)(?: response)?(?: at "(.*)")? as "(.*)"$/) do |path, key|
  RSpec::Oj.memorize(key, normalize_json(last_json, path))
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be:$/) do |path, negative, json|
  if negative
    expect(last_json).not_to be_json_eql(RSpec::Oj.remember(json)).at_path(path)
  else
    expect(last_json).to be_json_eql(RSpec::Oj.remember(json)).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be file "(.+)"$/) do |path, negative, file_path|
  if negative
    expect(last_json).not_to be_json_eql.to_file(file_path).at_path(path)
  else
    expect(last_json).to be_json_eql.to_file(file_path).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/) do |path, negative, value| # rubocop:disable Layout/LineLength
  if negative
    expect(last_json).not_to be_json_eql(RSpec::Oj.remember(value)).at_path(path)
  else
    expect(last_json).to be_json_eql(RSpec::Oj.remember(value)).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include:$/) do |path, negative, json|
  if negative
    expect(last_json).not_to include_json(RSpec::Oj.remember(json)).at_path(path)
  else
    expect(last_json).to include_json(RSpec::Oj.remember(json)).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include file "(.+)"$/) do |path, negative, file_path|
  if negative
    expect(last_json).not_to include_json.from_file(file_path).at_path(path)
  else
    expect(last_json).to include_json.from_file(file_path).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? include (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/) do |path, negative, value| # rubocop:disable Layout/LineLength
  if negative
    expect(last_json).not_to include_json(RSpec::Oj.remember(value)).at_path(path)
  else
    expect(last_json).to include_json(RSpec::Oj.remember(value)).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should have the following:$/) do |base, table|
  table.raw.each do |path, value|
    path = [base, path].compact.join('/')

    if value
      step %(the JSON at "#{path}" should be:), value
    else
      step %(the JSON should have "#{path}")
    end
  end
end

Then(/^the (?:JSON|json)(?: response)? should( not)? have "(.*)"$/) do |negative, path|
  if negative
    expect(last_json).not_to have_json_path(path)
  else
    expect(last_json).to have_json_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? be an? (.*)$/) do |path, negative, type|
  if negative
    expect(last_json).not_to have_json_type(type).at_path(path)
  else
    expect(last_json).to have_json_type(type).at_path(path)
  end
end

Then(/^the (?:JSON|json)(?: response)?(?: at "(.*)")? should( not)? have (\d+)/) do |path, negative, size|
  if negative
    expect(last_json).not_to have_json_size(size.to_i).at_path(path)
  else
    expect(last_json).to have_json_size(size.to_i).at_path(path)
  end
end
