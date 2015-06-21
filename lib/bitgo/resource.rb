module Bitgo
  class Resource
    @@attributes ||= []

    def self.attribute(attr)
      @@attributes << attr

      define_method attr do
        normalized_attr = attr.to_s.camelize(:lower)
        @data[attr] = @data[attr] || @raw_data[attr.to_s.camelize(:lower)]
        @data[attr]
      end

      define_method "#{attr}=" do |val|
        @data[attr] = val
      end
    end

    def self.attributes(*attrs)
      attrs.each do |attr|
        self.attribute(attr)
      end
    end

    attr_accessor :token, :data

    def initialize(token, raw_data={})
      @token    = token
      @raw_data = raw_data
      @data     = ActiveSupport::HashWithIndifferentAccess.new
    end

    def update_attributes(attrs={})
      attrs.each do |k, v|
        attr = k.to_s
        @data[attr] = v if @@attributes.include?(attr)
      end
    end
  end
end
