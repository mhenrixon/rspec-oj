# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RSpec::Oj::Matchers::HaveJsonType do
  it 'matches hashes' do
    hash = %({})
    expect(hash).to have_json_type(Hash)
    expect(hash).to have_json_type(:object)
  end

  it 'matches arrays' do
    expect(%([])).to have_json_type(Array)
  end

  it 'matches at a path' do
    expect(%({"root":[]})).to have_json_type(Array).at_path('root')
  end

  it 'matches strings' do
    expect(%(["rspec-oj"])).to have_json_type(String).at_path('0')
  end

  it 'matches a valid JSON value, yet invalid JSON document' do
    expect(%("rspec-oj")).to have_json_type(String)
  end

  it 'matches empty strings' do
    expect(%("")).to have_json_type(String)
  end

  it 'matches integers' do
    expect(%(10)).to have_json_type(Integer)
  end

  it 'matches floats' do
    expect(%(10.0)).to have_json_type(Float)
    expect(%(1e+1)).to have_json_type(Float)
  end

  it 'matches booleans' do
    expect(%(true)).to have_json_type(:boolean)
    expect(%(false)).to have_json_type(:boolean)
  end

  it 'matches ancestor classes' do
    expect(%(10)).to have_json_type(Numeric)
    expect(%(10.0)).to have_json_type(Numeric)
  end

  it 'provides a failure message' do
    matcher = have_json_type(Numeric)
    matcher.matches?(%("foo"))
    expect(matcher.failure_message).to eq 'Expected JSON value type to be Numeric, got String'
  end

  it 'provides a failure message for negation' do
    matcher = have_json_type(Numeric)
    matcher.matches?(%(10.0))

    expect(matcher.failure_message_when_negated).to eq 'Expected JSON value type to not be Numeric, got Float'
  end

  it 'provides a description message' do
    matcher = have_json_type(String)
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq %(have JSON type "String")
  end

  it 'provides a description message with path' do
    matcher = have_json_type(String).at_path('json')
    matcher.matches?(%({"id":1,"json":"spec"}))
    expect(matcher.description).to eq %(have JSON type "String" at path "json")
  end

  context 'when given a simple value' do
    it 'matches true' do
      expect(%(true)).to have_json_type(TrueClass)
    end

    it 'matches false' do
      expect(%(false)).to have_json_type(FalseClass)
    end

    it 'matches null' do
      null = %(null)
      expect(null).to have_json_type(NilClass)
      expect(null).to have_json_type(:nil)
      expect(null).to have_json_type(:null)
    end
  end
end
