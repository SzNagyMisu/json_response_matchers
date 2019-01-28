require "json"
require 'active_support/core_ext/hash/keys'
require 'rspec'

module JsonResponseMatchers
  class Base
    attr_reader :expected, :actual

    include RSpec::Matchers::Composable

    def initialize expected
      @expected = expected
    end

    def at_key *hash_keys
      @keys = hash_keys
      self
    end

    def diffable?
      true
    end


    private

      def extract_parsed_json_from json_or_response
        json = json_or_response.respond_to?(:body) ? json_or_response.body : json_or_response
        JSON.parse json
      end

      def fetch_from hash
        ( @keys || [] ).each { |key| hash = hash.fetch(Integer === key ? key : key.to_s) }
        hash
      end
  end
end
