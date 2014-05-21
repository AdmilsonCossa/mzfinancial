module Autocompleter
  class << self
    attr_accessor :models

    def setup
      self.models = []

      ActiveSupport.on_load(:active_record) do
        ::ActiveRecord::Base.send(:include, ActiveRecord)
      end
      ::ActiveAdmin::FormBuilder.send(:include, Formtastic::DefaultInputType)
    end

    def routes(router)
      valid_models = (self.models + self.models.flat_map(&:descendants))
        .map(&:name).map(&:underscore).join('|')

      router.instance_exec do
        get '/autocomplete/:model' => 'autocomplete#index',
          model: /(#{valid_models})/,
          defaults: { format: 'json' }
      end
    end
  end

  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def autocomplete(attribute, options = {})
        class_attribute :autocomplete_attribute
        class_attribute :autocomplete_options

        self.autocomplete_attribute = attribute
        self.autocomplete_options = options

        Autocompleter.models << self

        extend AutocompleteMethods
      end
    end

    module AutocompleteMethods
      def autocomplete_results(query)
        autocomplete_result_fetcher.call(query)
          .limit(autocomplete_result_limit)
          .map do |record|
            autocomplete_format_result(record)
          end
      end

      private

      def autocomplete_result_fetcher
        autocomplete_options[:result_fetcher] or ->(query) do
          where("LOWER(#{table_name}.#{autocomplete_attribute}::varchar) LIKE LOWER(?)",
            autocomplete_query(query),
          ).order(autocomplete_attribute)
        end
      end

      def autocomplete_query(query)
        "%#{query.split.join('%')}%"
      end

      def autocomplete_result_limit
        autocomplete_options[:limit] or 10
      end

      def autocomplete_format_result(record)
        {
          id: record.id,
          name: autocomplete_format_label(record).to_s,
        }
      end

      def autocomplete_format_label(record)
        case autocomplete_options[:format_label]
        when Symbol
          record.send(autocomplete_options[:format_label])
        when Proc
          autocomplete_options[:format_label].call(record)
        else
          record.send(autocomplete_attribute)
        end
      end
    end
  end

  module Formtastic
    module DefaultInputType
      extend ActiveSupport::Concern

      included do
        alias_method_chain :default_input_type, :token_input
        alias_method_chain :default_input_type, :token_multiple_input
      end

      def default_input_type_with_token_input(method, options = {})
        require 'formtastic/inputs/token_input.rb'
        if @object
          reflection = reflection_for(method)
          if reflection && reflection.klass.respond_to?(:autocomplete_attribute) && reflection.macro == :belongs_to
            return :token
          end
        end
        default_input_type_without_token_input(method, options)
      end

      def default_input_type_with_token_multiple_input(method, options = {})
        require 'formtastic/inputs/token_multiple_input.rb'
        if @object
          reflection = reflection_for(method)
          if reflection && reflection.klass.respond_to?(:autocomplete_attribute) && [:has_many, :has_and_belongs_to_many].include?(reflection.macro)
            return :token_multiple
          end
        end
        default_input_type_without_token_multiple_input(method, options)
      end
    end
  end
end
