require "json_response_matchers/base"

module JsonResponseMatchers
  class Content < Base
    def initialize expected
      super
      @exact = true
      if Hash === @expected
        @expected.deep_stringify_keys!
        @exact = false
      end
    end

    def failure_message
      "expected\n    #{@actual}\nto #{@exact ? 'equal' : 'include'}\n    #{@expected}"
    end


    def matches? actual
      @actual = fetch_from extract_parsed_json_from actual
      @exact ? @actual == @expected : hash_include?
    end

    def with_full_match
      @exact = true
      self
    end


    private

      def hash_include?
        @expected.all? { |key, expected_value| @actual[key.to_s] == expected_value }
      end
  end
end
