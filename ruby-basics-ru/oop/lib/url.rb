# frozen_string_literal: true

# BEGIN
require 'uri'
require 'forwardable'

def parse_query_string(query_string)
  query_string ||= ''
  params = {}
  query_string.split('&').each do |it|
    (key, value) = it.split '='
    params[key.to_sym] = value
  end
  params
end

def query_string_equal?(left, right)
  (left.size == right.size) && left.all? { |k, v| right.key?(k) && v == right[k] }
end

class Url
  attr_accessor :query_params

  include Comparable
  extend Forwardable

  def initialize(input)
    @uri = URI(input)
    @query_params = parse_query_string(@uri.query)
  end

  def_delegator :@uri, :scheme, :scheme
  def_delegator :@uri, :host, :host
  def_delegator :@uri, :port, :port

  def query_param(key, default = nil)
    @query_params.fetch(key, default)
  end

  def <=>(other)
    result = (scheme == other.scheme) &&
             (host == other.host) &&
             (port == other.port) &&
             query_string_equal?(query_params, other.query_params)
   result ? 0 : -1
  end
end
# END
