module Formtastic
  module Inputs
    class TokenMultipleInput
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
          class:     'token-input-multiple',
          :'data-model-name' => model_name,
          :'data-pre' => prepopulated_values.to_json,
        )
      end

      def model_name
        (input_options[:model] || reflection.klass).model_name.singular
      end

      def prepopulated_values
        records.map do |record|
          {
            id: record.id,
            name: name_value(record),
          }
        end
      end

      def records
        @object.send(method)
      end

      def name_value(record)
        record.send(name_method(record))
      end

      def name_method(record)
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
