# frozen_string_literal: true

module RSpec
  module Oj
    module Memory
      def memory
        @memory ||= {}
      end

      def memorize(key, value)
        memory[key.to_sym] = value
      end

      def remember(json)
        memory.empty? ? json : json % memory
      end

      def forget
        memory.clear
      end
    end
  end
end
