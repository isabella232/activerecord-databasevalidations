module ActiveModel
  module Validations
    class BytesizeValidator < ActiveModel::EachValidator
      def check_validity!
        unless options[:maximum].is_a?(Integer) && options[:maximum] >= 0
          raise ArgumentError, ":maximum must be set to a nonnegative Integer"
        end
      end

      def validate_each(record, attribute, value)
        bytesize = value.to_s.bytesize
        if bytesize > options[:maximum]
          errors_options = options.except(:too_many_bytes, :maximum)
          default_message = options[:too_many_bytes]
          errors_options[:count] = options[:maximum]
          errors_options[:message] ||= default_message if default_message
          record.errors.add(attribute, :too_many_bytes, errors_options)
        end
      end
    end

    module HelperMethods
      def validates_bytesize_of(*attr_names)
        validates_with ActiveModel::Validations::BytesizeValidator, _merge_attributes(attr_names)
      end
    end
  end
end
