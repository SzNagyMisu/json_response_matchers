require "json_response_matchers/base"

module JsonResponseMatchers
  class Values < Base

    def initialize expected
      super
      @check_order = false
    end

    def failure_message
      "expected\n    #{@actual}\nto #{@check_order ? 'equal' : 'match'}\n    #{@expected}"
    end


    def matches? actual
      raise ArgumentError, "You must set one or more attributes for mapping with #for:\n    have_json_values(#{@expected}).for(attribute_name(s))" unless @for
      @actual = fetch_from extract_parsed_json_from actual
      @actual = @actual.map do |item|
        @for.one? ? item[@for.first] : @for.map { |attribute| item[attribute] }
      end
      @check_order ? @actual == @expected : arrays_match?
    end

    def for *attributes
      @for = attributes.map &:to_s
      self
    end

    def in_strict_order
      @check_order = true
      self
    end


    private

      def arrays_match?
        expected = @expected.dup
        all_matches = @actual.all? do |actual_value|
          if expected.include? actual_value
            expected.delete actual_value
            true
          end
        end
        all_matches && expected.empty?
      end
  end
end
