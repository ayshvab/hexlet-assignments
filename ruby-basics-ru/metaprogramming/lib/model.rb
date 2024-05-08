# frozen_string_literal: true

# BEGIN
require 'date'
module Model
  def initialize(attrs = {})
    @attributes = {}
    self.class.attribute_options.each do |name, options|
      value = attrs.key?(name) ? attrs[name] : options.fetch(:default, nil)
      write_attribute(name, value)
    end
  end

  def write_attribute(name, value)
    options = self.class.attribute_options[name]
    @attributes[name] = self.class.convert(value, options[:type])
  end

  module ClassMethods
    def attribute_options
      @attribute_options || {}
    end

    def attribute(name, options = {})
      @attribute_options ||= {}
      attribute_options[name] = options

      define_method :"#{name}" do
        @attributes[name]
      end

      define_method :"#{name}=" do |value|
        write_attribute(name, value)
      end
    end

    def convert(value, target_type)
      return value if value.nil?

      case target_type
      when :datetime
        DateTime.parse value
      when :integer
        Integer value
      when :string
        String value
      when :boolean
        !!value
      end
    end
  end

  def self.included(base)
    base.attr_reader :attributes
    base.extend ClassMethods
  end
end

# module Model
#   def self.included(base)
#     base.extend ClassMethods
#   end
#
#   module ClassMethods
#     attr_reader :scheme
#
#     def attribute(name, options = {})
#       @scheme ||= {}
#       @scheme[name] = options
#
#       define_method name do
#         instance_variable_get("@#{name}")
#       end
#
#       define_method("#{name}=") do |value|
#         if options[:type] == :datetime
#           begin
#             instance_variable_set("@#{name}", DateTime.parse(value))
#           rescue
#             # TODO
#           end
#         else
#           instance_variable_set("@#{name}", value)
#         end
#       end
#     end
#   end
#
#   def attributes
#     result = {}
#     self.class.scheme.each do |k,_|
#       result[k] = send(k.to_sym)
#     end
#     result
#   end
#
#   def initialize(attributes = {})
#     self.class.scheme.each_pair do |name, options|
#       value = attributes.fetch(name, options[:default])
#       self.send("#{name}=", value)
#     end
#   end
# end
# END
