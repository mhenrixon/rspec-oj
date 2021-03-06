# frozen_string_literal: true

module RSpec
  module Oj
    module Matchers
      class HaveJsonSize
        include RSpec::Oj::Helpers
        include RSpec::Oj::Messages

        def initialize(size)
          @expected = size
          @path = nil
        end

        def matches?(json)
          ruby = parse_json(json, @path)
          raise EnumerableExpected, ruby unless Enumerable === ruby

          @actual = ruby.size
          @actual == @expected
        end

        def at_path(path)
          @path = path
          self
        end

        def failure_message
          message_with_path("Expected JSON value size to be #{@expected}, got #{@actual}")
        end

        def failure_message_when_negated
          message_with_path("Expected JSON value size to not be #{@expected}, got #{@actual}")
        end

        def description
          message_with_path(%(have JSON size "#{@expected}"))
        end
      end
    end
  end
end
