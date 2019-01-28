require "json_response_matchers/version"
require "json_response_matchers/content"
require "json_response_matchers/values"

module JsonResponseMatchers
  def have_json_values *values
    Values.new values
  end

  def have_json_content parsed_content
    Content.new parsed_content
  end
end
