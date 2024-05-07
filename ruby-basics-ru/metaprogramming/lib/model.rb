# frozen_string_literal: true

# BEGIN
module Model
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    attr_reader :scheme
    
    def attribute(name, options = {})
      @scheme ||= {}
      @scheme[name] = options
      
      define_method name do
        instance_variable_get("@#{name}")
      end
      
      define_method("#{name}=") do |value|
        if options[:type] == :datetime
          begin
            instance_variable_set("@#{name}", DateTime.parse(value))
          rescue
            # TODO
          end
        else
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
  
  def attributes
    result = {}
    self.class.scheme.each do |k,_|
      result[k] = send(k.to_sym)
    end
    result
  end

  def initialize(attributes = {})
    self.class.scheme.each_pair do |name, options|
      value = attributes.fetch(name, options[:default])
      self.send("#{name}=", value)
    end
  end
end
# END
