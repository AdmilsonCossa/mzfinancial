module Formtastic
  module Inputs
    class TokenInput
      include Base

      def to_html
        input_wrapping do
          label_html << builder.hidden_field(input_name, input_html_options)
        end
      end

      def input_html_options
        super.merge(
          required:  nil,
          autofocus: nil,
          class:     'token-input',
          :'data-model-name' => model_name,
        ).tap do |html_options|
          html_options['data-pre'] = prepopulated_value.to_json if record.present?
        end
      end

      def model_name
        (input_options[:model] || reflection.klass).model_name.singular
      end

      def prepopulated_value
        [{
          id: record.id,
          name: name_value,
        }]
      end

      def record
        @object.send(method)
      end

      def name_value
        record.send(name_method)
      end

      def name_method
        builder.collection_label_methods.find { |m| record.respond_to?(m) }
      end

      def association_primary_key
        association_primary_key_from_super = super
        if association_primary_key_from_super == method.to_sym
          :"#{method}_id"
        else
          association_primary_key_from_super
        end
      end
    end
  end
end
