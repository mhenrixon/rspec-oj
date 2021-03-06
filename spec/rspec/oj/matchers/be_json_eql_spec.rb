# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RSpec::Oj::Matchers::BeJsonEql do
  it 'matches identical JSON' do
    expect(%({"json":"spec"})).to be_json_eql(%({"json":"spec"}))
  end

  it 'matches differently-formatted JSON' do
    expect(%( { "json": "spec" } )).to be_json_eql(%({"json":"spec"}))
  end

  it 'matches out-of-order hashes' do
    expect(%({"laser":"lemon","json":"spec"})).to be_json_eql(%({"laser":"lemon","json":"spec"}))
  end

  it "doesn't match out-of-order arrays" do
    expect(%(["json","spec"])).not_to be_json_eql(%(["spec","json"]))
  end

  it 'matches valid JSON values, yet invalid JSON documents' do
    expect('rspec-oj').to be_json_eql('rspec-oj')
  end

  it 'matches at a path' do
    expect(%({"json":["spec"]})).to be_json_eql('spec').at_path('json/0')
  end

  it 'ignores excluded-by-default hash keys' do
    expect(RSpec::Oj.excluded_keys).not_to be_empty

    actual = expected = { 'json' => 'spec' }
    RSpec::Oj.excluded_keys.each { |k| actual[k] = k }
    expect(actual).to be_json_eql(expected)
  end

  it 'ignores custom excluded hash keys' do
    RSpec::Oj.exclude_keys('ignore')
    expect(%({"json":"spec","ignore":"please"})).to be_json_eql(%({"json":"spec"}))
  end

  it 'ignores nested, excluded hash keys' do
    RSpec::Oj.exclude_keys('ignore')
    expect(%({"json":"spec","please":{"ignore":"this"}})).to be_json_eql(%({"json":"spec","please":{}}))
  end

  it 'ignores hash keys when included in the expected value' do
    RSpec::Oj.exclude_keys('ignore')
    expect(%({"json":"spec","ignore":"please"})).to be_json_eql(%({"json":"spec","ignore":"this"}))
  end

  it "doesn't match Ruby-equivalent, JSON-inequivalent values" do
    expect(%({"one":1})).not_to be_json_eql(%({"one":1.0}))
  end

  it 'matches different looking, JSON-equivalent values' do
    expect(%({"ten":10.0})).to be_json_eql(%({"ten":10.0}))
  end

  it 'excludes extra hash keys per matcher' do
    RSpec::Oj.excluded_keys = %w[ignore]
    expect(%({"id":1,"json":"spec","ignore":"please"}))
      .to be_json_eql(%({"id":2,"json":"spec","ignore":"this"})).excluding('id')
  end

  it 'excludes extra hash keys given as symbols' do
    RSpec::Oj.excluded_keys = []
    expect(%({"id":1,"json":"spec"})).to be_json_eql(%({"id":2,"json":"spec"})).excluding(:id)
  end

  it 'excludes multiple keys' do
    RSpec::Oj.excluded_keys = []
    expect(%({"id":1,"json":"spec"})).to be_json_eql(%({"id":2,"json":"different"})).excluding(:id, :json)
  end

  it 'includes globally-excluded hash keys per matcher' do
    RSpec::Oj.excluded_keys = %w[id ignore]
    expect(%({"id":1,"json":"spec","ignore":"please"}))
      .not_to be_json_eql(%({"id":2,"json":"spec","ignore":"this"}))
      .including('id')
  end

  it 'includes globally-included hash keys given as symbols' do
    RSpec::Oj.excluded_keys = %w[id]
    expect(%({"id":1,"json":"spec"})).not_to be_json_eql(%({"id":2,"json":"spec"})).including(:id)
  end

  it 'includes multiple keys' do
    RSpec::Oj.excluded_keys = %w[id json]
    expect(%({"id":1,"json":"spec"})).not_to be_json_eql(%({"id":2,"json":"different"})).including(:id, :json)
  end

  it 'provides a description message' do
    matcher = be_json_eql(%({"id":2,"json":"spec"}))
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq('equal JSON')
  end

  it 'provides a description message with path' do
    matcher = be_json_eql(%({"id":1,"json":["spec"]})).at_path('json/0')
    matcher.matches?(%({"id":1,"json":["spec"]}))
    expect(matcher.description).to eq(%(equal JSON at path "json/0"))
  end

  it 'raises an error when not given expected JSON' do
    expect { expect(%({id: 1, json: 'spec'})).to be_json_eql }.to raise_error do |error|
      expect(error.message).to eq('Expected equivalent JSON not provided')
    end
  end

  it 'matches file contents' do
    RSpec::Oj.directory = files_path
    expect(%({"value":"from_file"})).to be_json_eql.to_file('one.json')
  end
end
